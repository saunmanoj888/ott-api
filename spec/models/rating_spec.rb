require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:rating) { create(:rating, user: user, video: movie) }

  it { should validate_presence_of(:value) }
  it do
    should validate_numericality_of(:value)
      .only_integer
      .is_greater_than_or_equal_to(1)
      .is_less_than_or_equal_to(5)
  end
  it do
    should validate_uniqueness_of(:video_id)
      .scoped_to(:user_id)
      .with_message('rating already submitted')
  end

  it { should belong_to(:video).counter_cache(true) }
  it { should belong_to(:user) }
end
