class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :body, :added_by

  def added_by
    object.user.full_name
  end
end
