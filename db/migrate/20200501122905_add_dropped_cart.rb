class AddDroppedCart < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :dropped_cart_processed_at, :timestamp
    add_column :membership_applications, :dropped_cart_mailchimp_status, :string, length: 3
    add_column :membership_applications, :dropped_cart_resumption_token, :string
    add_index :membership_applications, :dropped_cart_resumption_token, unique: true
  end
end
