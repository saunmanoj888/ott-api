require 'rails_helper'

RSpec.describe Person, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_many(:cast_crews) }
  it { should have_many(:videos).through(:cast_crews) }
end
