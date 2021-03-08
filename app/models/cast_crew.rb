class CastCrew < ApplicationRecord
  validates :profession_id, uniqueness: { scope: %i[video_id person_id] }

  belongs_to :person
  belongs_to :video
  belongs_to :profession

  delegate :name, to: :person
  delegate :designation, to: :profession
end
