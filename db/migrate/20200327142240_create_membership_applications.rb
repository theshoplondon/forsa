class CreateMembershipApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :membership_applications do |t|
      t.string :first_name
      t.string :email

      t.timestamps
    end
  end
end
