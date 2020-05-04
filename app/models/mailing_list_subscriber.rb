class MailingListSubscriber < MailingListSubscriberBase
  def list_id
    ENV['MAILCHIMP_LIST_ID']
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
end
