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
    expect(page).to have_content 'Step 1 of 5'

    # When I fill in more details
    fill_in 'Title', with: 'Mr.'
    fill_in 'Last', with: 'Memberapplication'
    fill_in 'Date of birth', with: '25/05/1975'
    choose 'membership_application_gender_male'

    # And I go to the next step
    click_button 'Next'

    expect(page).to have_content 'Contact details'
    expect(page).to have_content 'Step 2 of 5'

    # Then it has prefilled email
    expect(page).to have_css('input[value="mick@memberapplication.ie"]')

    # When I fill in further contact details
    fill_in 'Phone number', with: '0123456789'
    fill_in 'Home address', with: '20 Plankton Road'

    click_button 'Next'

    # And I fill in work details
    fill_in 'Your job title', with: 'User Researcher'
    fill_in 'Your employer', with: 'Office of Public Works'
    fill_in 'Your workplace address', with: <<~TXT
      Head Office
      Jonathan Swift Street
      Trim
      C15 NX36
    TXT
    fill_in 'Your payroll number', with: 'OE1234567'

    click_button 'Next'

    # And I fill in pay details
    fill_in 'What are you paid?', with: '29,250'

    choose 'membership_application_pay_unit_year'

    click_button 'Next'

    # And I fill in my declaration
    fill_in 'Sign your application by typing your name', with: 'Mick Memberapplication'

    VCR.use_cassette('mail_chimp_feature_subscribe') do
      click_button 'Finish'
    end

    # Then I see a temporary finishing page
    expect(page).to have_content 'Welcome to Fórsa!'

    # When I fill in the extra questions
    fill_in 'If you have been a member of a union, please tell us which one(s)',
            with: 'ITGWU'
    # including income protection
    choose 'Not at the moment, thanks'

    click_button 'Submit'

    # I should see a thank you
    expect(page).to have_content('Thanks for letting us know.')

    # And I should not see the post-join questions again
    expect(page).not_to have_content('Have you previously been a member of a union')

    # And we've captured what we needed to
    membership_application = MembershipApplication.last
    expect(membership_application.last_name).to eql('Memberapplication')
    expect(membership_application.date_of_birth).to eql(Date.new(1975, 5, 25))
    expect(membership_application.home_address).to eql('20 Plankton Road')
    expect(membership_application.pay_unit).to eql('year')
    expect(membership_application.pay_rate).to eql(BigDecimal(29250))
    expect(membership_application.current_step).to eql('declaration')
    expect(membership_application.previous_union).to eql('ITGWU')
    expect(membership_application.income_protection).to be false
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
    expect(page).to have_content 'Step 1 of 5'

    # When I neglect to fill in a field
    fill_in 'Title', with: 'Mr.'
    # fill_in 'Last', with: 'Memberapplication'
    fill_in 'Date of birth', with: '25/05/1975'

    # And I go to the next step
    click_button 'Next'

    # Then I should be held up on the same page
    expect(page).to have_content 'About you'
    expect(page).to have_content 'Step 1 of 5'
    expect(page).to have_content "can't be blank"
  end
end
