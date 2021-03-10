class Person < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :cast_crews
  has_many :movies, through: :cast_crews
end
