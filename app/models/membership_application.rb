class MembershipApplication < ApplicationRecord
  validates :first_name, presence: true
  validates :email, presence: true, format: {
    with: /\A.+@.+\..+\z/i,
    message: 'Enter a valid email address'
  }
  validates :email, uniqueness: true, on: :create

  # Step 1: About you
  validates :last_name, presence: true, if: -> { reached_step?('about-you') }
  validates :date_of_birth, presence: true, if: -> { reached_step?('about-you') }

  # Step 2: Contact details
  validates :phone_number, presence: true, if: -> { reached_step?('contact-details') }

  # Step 3: Work and pay
  validates :job_title, presence: true, if: -> { reached_step?('work-and-pay') }
  validates :employer, presence: true, if: -> { reached_step?('work-and-pay') }
  validates :work_address, presence: true, if: -> { reached_step?('work-and-pay') }
  validates :payroll_number, presence: true, if: -> { reached_step?('work-and-pay') }
  validates :pay_rate, presence: true, numericality: true, if: -> { reached_step?('work-and-pay') }
  def pay_rate=(value)
    value = value.gsub(/[€,]/, '') if value.is_a?(String)
    write_attribute(:pay_rate, value)
  end

  PAY_UNIT = %w[hour week month year].freeze
  validates :pay_unit, inclusion: { in: PAY_UNIT }, if: -> { reached_step?('work-and-pay') }

  def reached_step?(step)
    Steps.instance.reached_step?(self.current_step, step)
  end
end
