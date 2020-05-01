class DroppedCartMailingListSubscriber < MailingListSubscriberBase
  def list_id
    ENV['MAILCHIMP_DROPPED_CART_LIST_ID']
  end

  def subscriber_info
    {
      email_address: member.email,
      status: 'subscribed',
      merge_fields: {
        FNAME: member.first_name
      }
    }
  end
end
