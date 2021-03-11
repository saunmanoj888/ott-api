class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email

  has_many :ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :permissions

  after_create :set_default_non_admin_permissions

  def full_name
    "#{first_name} #{last_name}"
  end

  def can_access?(permission_name)
    permissions.named(permission_name).present?
  end

  private

  def set_default_non_admin_permissions
    permissions << Permission.non_admin_permissions
  end
end
