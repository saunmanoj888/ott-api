require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  it { should have_and_belong_to_many(:users).join_table(:users_roles) }
  it { should belong_to(:resource).optional }
end