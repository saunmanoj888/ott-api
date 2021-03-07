require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { create(:movie) }
  let(:rating_4) { create(:rating, video: movie) }
  let(:rating_3) { create(:rating, value: 3, video: movie) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:budget) }

  it { should have_many(:ratings).dependent(:destroy) }

  describe 'Instance Methods' do
    describe '#average_ratings' do
      context 'When ratings is present for the movie' do
        before do
          rating_4
          rating_3
        end

        it 'returns average of the ratings for the movie' do
          expect(movie.average_ratings).to eq(3.5)
        end
      end

      context 'When ratings is not present for the movie' do
        it 'returns zero' do
          expect(movie.average_ratings).to eq(0)
        end
      end
    end
  end
end
