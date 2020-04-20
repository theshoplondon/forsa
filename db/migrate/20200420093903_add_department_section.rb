class AddDepartmentSection < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :department_section, :string
  end
end
