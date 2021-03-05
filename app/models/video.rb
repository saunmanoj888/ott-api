class Video < ApplicationRecord
  validates_presence_of :title, :description, :budget

  has_many :ratings, dependent: :destroy
end
