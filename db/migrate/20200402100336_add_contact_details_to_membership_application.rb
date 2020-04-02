class AddContactDetailsToMembershipApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :phone_number, :string
  end
end
