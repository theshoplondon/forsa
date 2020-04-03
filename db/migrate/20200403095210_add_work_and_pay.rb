class AddWorkAndPay < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :job_title, :string
    add_column :membership_applications, :employer, :string
    add_column :membership_applications, :work_address, :string
    add_column :membership_applications, :payroll_number, :string
    add_column :membership_applications, :pay_rate, :decimal
    add_column :membership_applications, :pay_unit, :string
  end
end
