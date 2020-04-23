class MailingListSubscriber
  attr_reader :member

  def initialize(member)
    @member = member
  end

  def subscribe!
    mail_chimp.lists(list_id).members.create(body: subscriber_info)
  rescue Gibbon::MailChimpError => error
    raise unless error.title == 'Member Exists'
  end

  def subscriber_info
    {
      email_address: member.email,
      status: 'pending', # Required Mailchimp status
      merge_fields: {
        FNAME: member.first_name,
        LNAME: member.last_name,
        EMPNAME: member.employer,
        JOBTITLE: member.job_title,
        SUBRATE: subscription_rate.monthly_estimate,
        SIGNED_ON: member.updated_at.strftime('%d/%m/%Y')
      }
    }
  end

  def subscription_rate
    @subscription_rate ||= SubscriptionRate.new(
      member.pay_rate,
      member.pay_unit,
      hours_per_week: member.hours_per_week,
      clerical_rate: member.clerical?
    )
  end

  private

  def mail_chimp
    @mail_chimp ||= Gibbon::Request.new
  end

  def list_id
    ENV['MAILCHIMP_LIST_ID']
  end
end
