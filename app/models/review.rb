class Review < ApplicationRecord

  validates_presence_of :body
  validates_uniqueness_of :movie_id, scope: :user_id, message: 'review already submitted'

  belongs_to :user
  belongs_to :movie
end
