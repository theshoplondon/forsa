class MembershipApplication < ApplicationRecord
  after_initialize :init

  validates :first_name, presence: true
  validates :email, presence: true, format: {
    with: /\A.+@.+\..+\z/i,
    message: 'Enter a valid email address'
  }

  # Step 1: About you
  GENDER = %w[male female non-binary other]
  validates :last_name, presence: true, if: -> { reached_step?('about-you') }
  validates :gender, inclusion: { in: GENDER }, if: -> { reached_step?('about-you') }
  validates :date_of_birth, presence: true, if: -> { reached_step?('about-you') }

  # Step 2: Contact details
  validates :phone_number, presence: true, if: -> { reached_step?('contact-details') }
  validates :home_address, presence: true, if: -> { reached_step?('contact-details') }

  # Step 3: Your work
  validates :job_title, presence: true, if: -> { reached_step?('your-work') }
  validates :employer, presence: true, if: -> { reached_step?('your-work') }
  validates :work_address, presence: true, if: -> { reached_step?('your-work') }
  validates :payroll_number, presence: true, if: -> { reached_step?('your-work') }

  TECHNICAL_GRADES = {
    'clerical'  => 'Clerical Officer',
    'executive' => 'Executive Officer',
    'other'     => 'Other grade',
    'na_unsure' => 'Not sure/doesn\'t apply'
  }.freeze
  validates :technical_grade, inclusion: { in: TECHNICAL_GRADES.keys }, if: -> { reached_step?('your-work') }
  validates :school_roll_number, allow_blank: true, format: /[0-9]{5}[A-Z][a-z]/, if: -> { reached_step?('your-work') }

  # Step 4: Your subscription rate
  validates :pay_rate, presence: true, numericality: true, if: -> { reached_step?('your-subscription-rate') }
  def pay_rate=(value)
    write_attribute(:pay_rate, SubscriptionRate.sanitize_currency(value))
  end

  PAY_UNIT = %w[hour week month year].freeze
  validates :pay_unit, inclusion: { in: PAY_UNIT }, if: -> { reached_step?('your-subscription-rate') }
  validates :hours_per_week, numericality: true,
    if: -> { reached_step?('your-subscription-rate') && pay_unit == 'hour' }

  # Step 4: Declaration
  attribute :declaration, :string
  validate :declaration_is_signed, if: -> { reached_step?('declaration') }

  # Scopes
  scope :signed, -> { where(current_step: 'declaration') }

  def init
    self.technical_grade = TECHNICAL_GRADES.keys.last # N/A or unsure
  end

  def declaration_is_signed
    errors[:declaration] << %(must be "#{full_name}") unless declaration == full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def reached_step?(step)
    Steps.instance.reached_step?(self.current_step, step)
  end

  def completed?
    current_step == 'declaration' && persisted? && !changed?
  end

  def as_json(options = {})
    exclude = %w[declaration current_step]
    super(options).except(*exclude)
  end
end
