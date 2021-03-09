class RatingSerializer < ActiveModel::Serializer
  attributes :id, :value, :added_by

  def added_by
    object.user.full_name
  end
end
