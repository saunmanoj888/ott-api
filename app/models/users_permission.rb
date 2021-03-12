class UsersPermission < ApplicationRecord
  validates_uniqueness_of :permission_id, scope: :user_id

  belongs_to :permission
  belongs_to :user
end
