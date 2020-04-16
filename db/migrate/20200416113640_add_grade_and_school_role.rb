class AddGradeAndSchoolRole < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :school_roll_number, :string
    add_column :membership_applications, :technical_grade, :string
  end
end
