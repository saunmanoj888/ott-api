class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email

  has_many :ratings, dependent: :destroy
  has_and_belongs_to_many :permissions

  def full_name
    "#{first_name} #{last_name}"
  end
end
