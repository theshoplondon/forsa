class AddHomeAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :home_address,:string
  end
end
