class AddPostJoinQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_applications, :previous_union, :string
    add_column :membership_applications, :income_protection, :boolean, default: true

    add_column :membership_applications, :completed, :boolean, default: false, null: false
    add_column :membership_applications, :answered_post_join, :boolean, default: false, null: false
  end
end
