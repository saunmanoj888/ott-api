class CastCrew < ApplicationRecord
  validates :profession_id, uniqueness: { scope: %i[movie_id person_id] }

  belongs_to :person
  belongs_to :movie
  belongs_to :profession
end
