class CastCrewSerializer < ActiveModel::Serializer
  attributes :name, :designation, :character

  def name
    object.person.name
  end

  def designation
    object.profession.designation
  end
end
