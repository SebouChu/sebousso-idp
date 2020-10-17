class AddAdditionalInfosToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :blog_role, :integer, default: 0
    add_column :users, :video_role, :integer, default: 0
  end
end
