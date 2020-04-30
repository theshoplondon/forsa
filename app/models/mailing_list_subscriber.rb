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
      status: 'subscribed',
      merge_fields: {
        FNAME: member.first_name,
        LNAME: member.last_name,
        ADDRESS: member.home_address.gsub("\n", "<br />"), # MC requires BR to preserve line breaks
        PHONE: member.phone_number,
        EMPNAME: member.employer,
        EMPADDRESS: member.work_address.gsub("\n", "<br />"), # MC requires BR to preserve line breaks,
        PAYROLLNO: member.payroll_number,
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
