class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :release_date, :budget, :average_ratings

  has_many :reviews
  has_many :cast_crews
end
