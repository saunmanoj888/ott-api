class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :body, :added_by
end
