require 'rails_helper'

RSpec.describe CastCrew, type: :model do
  it { should validate_uniqueness_of(:profession_id).scoped_to(%i[movie_id person_id]) }

  it { should belong_to(:movie) }
  it { should belong_to(:person) }
  it { should belong_to(:profession) }
end
