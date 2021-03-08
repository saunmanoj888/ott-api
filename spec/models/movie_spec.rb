require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { create(:movie) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:budget) }

  it { should have_many(:ratings).dependent(:destroy) }
  it { should have_many(:cast_crews) }
  it { should have_many(:people).through(:cast_crews) }

  describe 'Instance Methods' do
    describe '#average_ratings' do
      context 'When ratings is present for the movie' do
        before do
          create(:rating, video: movie)
          create(:rating, value: 3, video: movie)
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
