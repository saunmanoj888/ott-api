class UsersPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :permission
    end

    add_index :permissions_users, [:permission_id, :user_id], unique: true
  end
end
