module Forsa
  class DroppedCart
    attr_reader :logger

    def initialize(logger = STDERR)
      @logger = logger
    end

    def dropped_applications
      MembershipApplication.dropped_cart
    end

    def subscribe_dropped_applications
      dropped_applications.each do |application|
        begin
          DroppedCartMailingListSubscriber.new(application).subscribe! if application.dropped_cart_processed_at.nil?
          application.update(dropped_cart_mailchimp_status: '200')
        rescue Gibbon::MailChimpError => e
          logger.error(e)
          application.update(dropped_cart_mailchimp_status: e.status_code)
        end
        application.touch(:dropped_cart_processed_at)
      end
    end
  end
end
