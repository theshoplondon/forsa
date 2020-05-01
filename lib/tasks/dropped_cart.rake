namespace :dropped_cart do
  desc 'Send emails to dropped carts'
  task send_emails: :environment do
    MembershipApplication.dropped_cart.find_each do |application|
      puts "#{application.email} #{application.current_step} #{application.updated_at}"
    end
  end
end
