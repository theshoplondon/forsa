require 'rails_helper'

RSpec.describe MailingListSubscriber do
  # These tests are set to record new cassettes.
  # They will do so if the URL or the post body changes.
  # They won't if the API key changes, so if you need to add new
  # tests, use your currently-working API key in .env.test
  # and once you've recorded tests that work, expire the key
  # at https://us5.admin.mailchimp.com/account/api/
  describe '#subscribe!', :vcr do
    let(:membership_application) { create(:membership_application, :step_declaration) }
    subject(:subscriber) { MailingListSubscriber.new(membership_application) }

    context 'the user isn\'t already subscribed',
      vcr: { cassette_name: 'user_not_already_subscribed', record: :new_episodes } \
    do
      before do
        membership_application.email = 'thisisme@zephyros-systems.co.uk'
      end

      it 'successfully adds new members as "pending" to MailChimp' do
        subscriber.subscribe!

        assert_subscribed membership_application.email, 'Natalie', 'Zurbman', 'Office of Public Works'
      end
    end

    context 'the user is already subscribed',
      vcr: { cassette_name: 'user_already_subscribed', record: :new_episodes } \
    do
      it 'acts without error as the effect is the same' do
        subscriber.subscribe!
      end
    end

    context 'there is a MailChimp error',
      vcr: { cassette_name: 'mail_chimp_error', record: :new_episodes } \
    do
      let(:membership_application) { create :membership_application, :step_new }
      it 'raises via Gibbon' do
        expect { subscriber.subscribe! }.to raise_error(
          Gibbon::MailChimpError, /the server responded with status 400/
        )
      end
    end
  end

  private

  def assert_subscribed(email, first_name, last_name, employer_name)
    email_hash = Digest::MD5.hexdigest email
    gibbon = Gibbon::Request.new
    list_id = ENV['MAILCHIMP_LIST_ID']

    response = gibbon.lists(list_id).members(email_hash).retrieve

    assert_equal email, response.body['email_address']
    assert_equal first_name, response.body['merge_fields']['FNAME']
    assert_equal last_name, response.body['merge_fields']['LNAME']
    assert_equal employer_name, response.body['merge_fields']['EMPNAME']
  end
end
