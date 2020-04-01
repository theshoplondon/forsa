require 'rails_helper'

# As a member of staff at one of the employers
# I want to join Fórsa
# So that my rights can be protected
feature 'A new member joins' do
  scenario 'everything goes to plan' do
    visit '/'
    expect(page).to have_content('Join Today')

    fill_in 'First name', with: 'Mick Memberapplication'
    fill_in 'Email address', with: 'mick@memberapplication.ie'

    click_button 'Get started'

    membership_application = MembershipApplication.first

    expect(membership_application.first_name).to eql('Mick Memberapplication')
    expect(membership_application.email).to eql('mick@memberapplication.ie')
  end
end
