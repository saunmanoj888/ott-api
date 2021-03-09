class Movie < ApplicationRecord
  validates_presence_of :title, :description, :budget

  has_many :ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :cast_crews, dependent: :destroy
  has_many :people, through: :cast_crews

  def average_ratings
    return 0 if ratings.blank?

    (ratings_sum / ratings_count).round(2)
  end

  private

  def ratings_sum
    ratings.pluck(:value).sum.to_f
  end
end
