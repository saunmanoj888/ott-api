require 'rails_helper'

RSpec.describe Profession, type: :model do
  it { should validate_presence_of(:designation) }
  it { should validate_uniqueness_of(:designation) }
end
