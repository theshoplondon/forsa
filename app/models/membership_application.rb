class MembershipApplication < ApplicationRecord
  validates :first_name, presence: true
  validates :email, presence: true, format: {
    with: /\A.+@.+\..+\z/i,
    message: 'Enter a valid email address'
  }
  validates :email, uniqueness: true, on: :create

  validates :last_name, presence: true, if: -> { reached_step?('about-you') }
  validates :date_of_birth, presence: true, if: -> { reached_step?('about-you') }

  validates :phone_number, presence: true, if: -> { reached_step?('contact-details') }

  def reached_step?(step)
    Steps.instance.reached_step?(self.current_step, step)
  end
end
