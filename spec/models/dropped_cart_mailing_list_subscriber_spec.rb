require 'rails_helper'

RSpec.describe DroppedCartMailingListSubscriber do
  describe '#subscriber_info' do
    let(:membership_application) { create(:membership_application, :step_your_work) }
    subject(:subscriber) { DroppedCartMailingListSubscriber.new(membership_application) }

    it 'has a resumption URL' do
      expect(subscriber.subscriber_info).to eql(
        email_address: membership_application.email,
        status: 'subscribed',
        merge_fields: {
          FNAME: membership_application.first_name,
          RESUME: "http://example.com/membership-application/resume/" \
                  "#{membership_application.dropped_cart_resumption_token}"
        }
      )
    end
  end
end
