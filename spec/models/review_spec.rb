require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:review) { create(:review, user: user, video: movie) }

  it { should validate_presence_of(:body) }
  it do
    should validate_uniqueness_of(:video_id)
      .scoped_to(:user_id)
      .with_message('review already submitted')
  end

  it { should delegate_method(:full_name).to(:user) }
  it { should belong_to(:video) }
  it { should belong_to(:user) }

  describe 'Instance Method' do
    describe '#added_by' do
      it 'returns the full name of User who added the review' do
        expect(review.added_by).to eq(user.full_name)
      end
    end
  end
end
