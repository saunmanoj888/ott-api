require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:non_admin_user) { create(:user, :non_admin) }
  let(:movie) { create(:movie) }
  let(:valid_params) { { review: { body: 'Must watch' } } }

  describe 'GET /api/v1/movies/:movie_id/reviews' do
    context 'When User is logged in' do
      before do
        login(admin_user)
        create(:review, user: admin_user, movie: movie)
      end

      it 'returns all reviews for the movie' do
        get "/api/v1/movies/#{movie.id}/reviews"
        expect(json).not_to be_empty
        expect(json['reviews'].size).to eq(1)
        expect(json['reviews'].first).to have_key('id')
        expect(response).to have_http_status(200)
      end
    end

    context 'When User is logged out' do
      it 'returns a failure message' do
        get "/api/v1/movies/#{movie.id}/reviews"
        expect(response.body).to match(/Please log in/)
      end
    end
  end

  describe 'POST /api/v1/movies/:movie_id/reviews' do
    context 'When User is logged in' do
      before { login(admin_user) }

      context 'When User has not reviewed the movie yet' do
        it 'creates a new review for the movie with valid attribute' do
          post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
          expect(json['review']['body']).to eq('Must watch')
        end

        it 'returns a validation message with invalid attribute' do
          post "/api/v1/movies/#{movie.id}/reviews", params: { review: { body: nil } }
          expect(response.body).to match(/Body can't be blank/)
        end
      end

      context 'When User has already reviewed the movie' do
        before { create(:review, user: admin_user, movie: movie) }
        it 'does not allow to add review again' do
          post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
          expect(response.body).to match(/Movie review already submitted/)
        end
      end
    end

    context 'When User is logged out' do
      it 'return a login failure message' do
        post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
        expect(response.body).to match(/Please log in/)
      end
    end
  end

  describe 'PUT /api/v1/reviews/:id' do
    let(:review) { create(:review, user: admin_user, movie: movie) }

    context 'When User is logged in' do
      context 'When review belongs to the User' do
        before { login(review.user) }
        it 'updates the review successfully with valid attributes' do
          put "/api/v1/reviews/#{review.id}", params: valid_params
          expect(json['review']['body']).to eq('Must watch')
        end
        it 'returns a validation message with invalid attributes' do
          put "/api/v1/reviews/#{review.id}", params: { review: { body: nil } }
          expect(response.body).to match(/Body can't be blank/)
        end
      end
      context 'When review does not belongs to the User' do
        before { login(create(:user)) }
        it 'returns a unauthorised failure message' do
          put "/api/v1/reviews/#{review.id}", params: valid_params
          expect(response.body).to match(/Not authorized to update Review./)
        end
      end
    end

    context 'When User is logged out' do
      it 'returns a login failure message' do
        put "/api/v1/reviews/#{review.id}", params: valid_params
        expect(response.body).to match(/Please log in/)
      end
    end
  end
end
