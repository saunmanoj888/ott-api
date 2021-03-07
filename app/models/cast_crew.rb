class CastCrew < ApplicationRecord
  validates :designation, presence: true, uniqueness: { scope: %i[video_id person_id] }

  belongs_to :person
  belongs_to :video
end
