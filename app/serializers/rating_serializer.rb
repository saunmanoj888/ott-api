class RatingSerializer < ActiveModel::Serializer
  attributes :id, :value, :added_by
end
