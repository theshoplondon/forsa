class DroppedCartMailingListSubscriber < MailingListSubscriberBase
  include Rails.application.routes.url_helpers

  def list_id
    ENV['MAILCHIMP_DROPPED_CART_LIST_ID']
  end

  def subscriber_info
    {
      email_address: member.email,
      status: 'subscribed',
      merge_fields: {
        FNAME: member.first_name,
        RESUME: resume_membership_application_url(member.dropped_cart_resumption_token)
      }
    }
  end
end
