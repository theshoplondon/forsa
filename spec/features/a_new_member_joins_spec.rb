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

    # And I go to the next step
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

    expect(page).to have_content 'Contact details'
    expect(page).to have_content 'Step 2 of 4'

    # Then it has prefilled email
    expect(page).to have_css('input[value="mick@memberapplication.ie"]')

    # When I fill in further contact details
    fill_in 'Phone number', with: '0123456789'

    click_button 'Next'

    # And I fill in work and pay details
    fill_in 'Your job title', with: 'User Researcher'
    fill_in 'Your employer', with: 'Office of Public Works'
    fill_in 'Your work place', with: <<~TXT
      Head Office
      Jonathan Swift Street
      Trim
      C15 NX36
    TXT
    fill_in 'Your payroll number', with: 'OE1234567'
    fill_in 'What are you paid?', with: '29,250'

    choose 'membership_application_pay_unit_year'

    click_button 'Next'

    # And I fill in my declaration
    fill_in 'Sign your application by typing your name', with: 'Mick Memberapplication'

    click_button 'Finish'

    # Then I see a temporary finishing page
    expect(page).to have_content 'Application complete'

    # And we've captured what we needed to
    membership_application = MembershipApplication.last
    expect(membership_application.last_name).to eql('Memberapplication')
    expect(membership_application.date_of_birth).to eql(Date.new(1975, 5, 25))
    expect(membership_application.pay_unit).to eql('year')
    expect(membership_application.pay_rate).to eql(BigDecimal(29250))
    expect(membership_application.current_step).to eql('declaration')
  end

  scenario 'one step fails validation' do
    # When I go to the front page
    visit '/'
    expect(page).to have_content('Join Today')

    # And I fill in the details
    fill_in 'First name', with: 'Mick'
    fill_in 'Email address', with: 'mick@memberapplication.ie'

    # When I go to the next step
    click_button 'Get started'

    expect(page).to have_content 'About you'
    expect(page).to have_content 'Step 1 of 4'

    # When I neglect to fill in a field
    fill_in 'Title', with: 'Mr.'
    # fill_in 'Last', with: 'Memberapplication'
    fill_in 'Date of birth', with: '25/05/1975'

    # And I go to the next step
    click_button 'Next'

    # Then I should be held up on the same page
    expect(page).to have_content 'About you'
    expect(page).to have_content 'Step 1 of 4'
    expect(page).to have_content "can't be blank"
  end
end
