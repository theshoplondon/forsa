class AddHoursPerWeek < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :hours_per_week, :decimal
  end
end
