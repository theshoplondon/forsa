class AddGender < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :gender, :string
  end
end
