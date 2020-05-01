namespace :dropped_cart do
  desc 'Send emails to dropped carts'
  task send_emails: :environment do
    require 'forsa/dropped_cart'
    Forsa::DroppedCart.new(Rails.logger).subscribe_dropped_applications
  end
end
