require 'rails_helper'

# As a member of staff at one of the employers
# I want to join Fórsa
# So that my rights can be protected
feature 'A new member joins' do
  scenario 'everything goes to plan' do
    visit '/'
    expect(page).to have_content('Join Today')
  end
end
