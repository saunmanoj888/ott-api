class Rating < ApplicationRecord
  include ReviewableDelegate

  validates_presence_of :value
  validates_numericality_of :value,
                            only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5

  validates_uniqueness_of :video_id, scope: :user_id, message: 'rating already submitted'

  belongs_to :user
  belongs_to :video, counter_cache: true
end
