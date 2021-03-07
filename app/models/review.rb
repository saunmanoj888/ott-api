class Review < ApplicationRecord
  include RateableDelegate

  validates_presence_of :body
  validates_uniqueness_of :video_id, scope: :user_id, message: 'review already submitted'

  belongs_to :user
  belongs_to :video
end
