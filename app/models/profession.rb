class Profession < ApplicationRecord
  validates_presence_of :designation
  validates_uniqueness_of :designation
end
