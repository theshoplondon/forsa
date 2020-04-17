class AddApplicantSawMonthlyEstimate < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :applicant_saw_monthly_estimate, :decimal
  end
end
