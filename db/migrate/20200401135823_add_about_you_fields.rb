class AddAboutYouFields < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :title, :string
    add_column :membership_applications, :last_name, :string
    add_column :membership_applications, :date_of_birth, :date
  end
end
