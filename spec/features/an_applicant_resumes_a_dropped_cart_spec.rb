require 'rails_helper'

feature 'An applicant resumes from a dropped cart' do
  scenario 'an applicant is resuming from a link sent in an email' do
    # Given that I have an email with a link in it
    application = create :membership_application, :step_contact_details, first_name: 'Saoirse'

    # When I click the link
    visit "/membership-application/resume/#{application.dropped_cart_resumption_token}"

    # Then I should see the 'about you' step with my first name filled in
    expect(page).to have_content('About you')
    expect(page).to have_content('Step 1 of 5')
    expect(page).to have_selector('input[value=Saoirse]')
  end
end
