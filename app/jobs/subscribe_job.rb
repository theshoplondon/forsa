##
# Subscribe new applicants to our mailing list
class SubscribeJob
  include SuckerPunch::Job

  def perform(membership_application_id)
    ActiveRecord::Base.connection_pool.with_connection do
      membership_application = MembershipApplication.find(membership_application_id)
      MailingListSubscriber.new(membership_application).subscribe!
    end
  end
end
