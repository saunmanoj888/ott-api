require 'rails_helper'

RSpec.describe CastCrew, type: :model do
  it { should validate_uniqueness_of(:profession_id).scoped_to(%i[video_id person_id]) }

  it { should belong_to(:video) }
  it { should belong_to(:person) }
  it { should belong_to(:profession) }

  it { should delegate_method(:name).to(:person) }
  it { should delegate_method(:designation).to(:profession) }
end
