require 'rails_helper'

def given_i_am_logged_in_as_an_admin
  User.create(email: 'admin@forsa.ie', password: 'verystr0ngpassword')

  # When I go to the admin login page
  visit new_user_session_path

  # And I enter that user's credentials
  fill_in 'Email', with: 'admin@forsa.ie'
  fill_in 'Password', with: 'verystr0ngpassword'

  # And I go to log in
  click_button 'Log in'
end

# As an admin
# I want to log in
# So that I can do admin things
feature 'View unprocessed membership applications' do
  def given_there_are_signed_applications(number)
    @signed_applications = FactoryBot.create_list(:membership_application, number, :step_declaration)
    @unsigned_application = FactoryBot.create(:membership_application, :step_work_and_pay)
  end

  scenario 'everything goes to plan' do
    given_there_are_signed_applications(2)

    given_i_am_logged_in_as_an_admin

    # Then I see the admin front page
    expect(page).to have_content('Signed in as admin')

    # And I see some applications
    expect(page).to have_selector('.membership-application', count: @signed_applications.count)
  end
end
