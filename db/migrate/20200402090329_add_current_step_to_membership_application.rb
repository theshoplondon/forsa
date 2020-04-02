class AddCurrentStepToMembershipApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :current_step, :string
  end
end
