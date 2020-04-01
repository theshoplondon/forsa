require 'rails_helper'

# As a member of staff at one of the employers
# I want to join Fórsa
# So that my rights can be protected
feature 'A new member joins' do
  scenario 'everything goes to plan' do
    # When I go to the front page
    visit '/'
    expect(page).to have_content('Join Today')

    # And I fill in the details
    fill_in 'First name', with: 'Mick'
    fill_in 'Email address', with: 'mick@memberapplication.ie'

    # When I go to the next step
    click_button 'Get started'

    # Then it prefills the first name
    expect(page).to have_css('input[value="Mick"]')

    expect(page).to have_content 'About you'
    expect(page).to have_content 'Step 1 of 4'

    # When I fill in more details
    fill_in 'Title', with: 'Mr.'
    fill_in 'Last', with: 'Memberapplication'
    fill_in 'Date of birth', with: '25/05/1975'

    # And I go to the next step
    click_button 'Next'

    # Then I see a temporary finishing page
    expect(page).to have_content 'Hi there, this is the end'

    # And we've captured Stuff
    membership_application = MembershipApplication.last
    expect(membership_application.last_name).to eql('Memberapplication')
    expect(membership_application.date_of_birth).to eql(Date.new(1975, 5, 25))
  end
end
