require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:budget) }

  it { should have_many(:ratings).dependent(:destroy) }
end
