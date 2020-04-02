class MembershipApplication < ApplicationRecord
  validates :first_name, presence: true
  validates :email, presence: true, format: {
    with: /\A.+@.+\..+\z/i,
    message: 'Enter a valid email address'
  }
  validates :email, uniqueness: true, on: :create

  validates :last_name, presence: true, if: -> { reached_step?('about-you') }
  validates :date_of_birth, presence: true, if: -> { reached_step?('about-you') }

  def reached_step?(_step)
    current_step == 'about-you'
  end
end
