class CreateUsersPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :users_permissions do |t|
      t.references :permission
      t.references :user

      t.timestamps
    end
  end
end
