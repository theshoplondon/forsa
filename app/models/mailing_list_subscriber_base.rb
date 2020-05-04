class MailingListSubscriberBase
  attr_reader :member

  def initialize(member)
    @member = member
  end

  def subscribe!
    mail_chimp.lists(list_id).members.create(body: subscriber_info)
  rescue Gibbon::MailChimpError => error
    raise unless error.title == 'Member Exists'
  end

  private

  def mail_chimp
    @mail_chimp ||= Gibbon::Request.new
  end

  def list_id
    raise NotImplementedError, 'subclass this base and add a list id'
  end

  def subscriber_info
    raise NotImplementedError, 'subclass this base and add a subscriber_info hash'
  end
end
