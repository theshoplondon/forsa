require 'rails_helper'

#
# Note this file is only for browser-based admin interactions. For API interactions,
# see the request specs.
#

def given_i_am_logged_in_as_an_admin
  user = User.create(email: 'admin@forsa.ie', password: 'verystr0ngpassword')

  # When I go to the admin login page
  visit new_user_session_path

  # And I enter that user's credentials
  fill_in 'Email', with: 'admin@forsa.ie'
  fill_in 'Password', with: 'verystr0ngpassword'

  # And I go to log in
  click_button 'Log in'
  user
end

# As an admin
# I want to log in
# So that I can do admin things
feature 'View unprocessed membership applications' do
  def given_there_are_signed_applications(number)
    @signed_applications = FactoryBot.create_list(:membership_application, number, :step_declaration)
    @unsigned_application = FactoryBot.create(:membership_application, :step_your_work)
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

feature 'self-serve API tokens' do
  include TokenAuthenticationHelpers

  scenario 'I see my last unexpired token, expire it, and create a new one' do
    user = given_i_am_logged_in_as_an_admin

    # Given I have an active token
    make_valid_api_credentials(user)
    token = AuthenticationToken.last

    # When I visit my own user page
    click_link 'admin@forsa.ie'

    # Then I see my token digests
    expect(page).to have_content 'My Active Tokens'
    expect(page).to have_content token.body

    # When I remove the only token
    click_link 'Remove'

    # Then I should see the list is empty
    expect(page).to have_content('There are no active tokens for this user.')

    # When I create a new one
    expect(Devise.token_generator).to receive(:generate).and_return('a_friendly_token')
    click_button 'Create new'

    # Then I should see the friendly token
    # And I should be advised to copy it now as this is the only time it will be shown
    expect(page).to have_content(
      "Token created. Copy this now as it is the last time you will be able to see it: a_friendly_token"
    )
  end
end
