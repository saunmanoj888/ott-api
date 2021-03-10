require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:review) { create(:review, user: user, movie: movie) }

  it { should validate_presence_of(:body) }
  it do
    should validate_uniqueness_of(:movie_id)
      .scoped_to(:user_id)
      .with_message('review already submitted')
  end

  it { should belong_to(:movie) }
  it { should belong_to(:user) }
end
