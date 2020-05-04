namespace :dropped_cart do
  desc 'Send emails to dropped carts'
  task send_emails: :environment do
    require 'forsa/dropped_cart'
    Forsa::DroppedCart.new(Rails.logger).subscribe_dropped_applications
  end

  desc 'backfill tokens for incomplete apps'
  task backfill_tokens: :environment do
    MembershipApplication.incomplete.find_each do |application|
      application.regenerate_dropped_cart_resumption_token if application.dropped_cart_resumption_token.nil?
    end
  end
end
