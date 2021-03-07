class Video < ApplicationRecord
  validates_presence_of :title, :description, :budget

  has_many :ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  def average_ratings
    return 0 if ratings.blank?

    (ratings_sum / ratings_count).round(2)
  end

  private

  def ratings_sum
    ratings.pluck(:value).sum.to_f
  end
end