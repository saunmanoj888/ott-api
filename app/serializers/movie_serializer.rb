class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :release_date, :budget, :average_ratings

  has_many :reviews

  def average_ratings
    (object.ratings_sum / object.ratings_count).round(2)
  end
end
