module Forsa
  class DroppedCart
    attr_reader :logger

    def initialize(logger = STDERR)
      @logger = logger
    end

    def dropped_applications
      @dropped_applications ||= MembershipApplication.dropped_cart
    end

    def subscribe_dropped_applications
      logger.info "Beginning Forsa::DroppedCart#subscribe_dropped_applications "\
                  "for #{dropped_applications.count} dropped applications"

      dropped_applications.each do |application|
        logger.info "Processing dropped application #{application.id}"

        begin
          DroppedCartMailingListSubscriber.new(application).subscribe! if application.dropped_cart_processed_at.nil?
          application.update(dropped_cart_mailchimp_status: '200')
        rescue Gibbon::MailChimpError => e
          logger.error(e)
          application.update(dropped_cart_mailchimp_status: e.status_code)
        end
        application.touch(:dropped_cart_processed_at)
      end

      logger.info "Finished Forsa::DroppedCart#subscribe_dropped_applications"
    end
  end
end
