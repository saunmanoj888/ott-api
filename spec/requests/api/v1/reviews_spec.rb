require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:valid_params) { { review: { body: 'Must watch' } } }

  describe 'GET /api/v1/movies/:movie_id/reviews' do
    context 'When User is logged in' do
      before do
        login
        create(:review, user: user, video: movie)
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
      before do
        login
        set_current_user(user)
      end

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
        before { create(:review, user: user, video: movie) }
        it 'does not allow to add review again' do
          post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
          expect(response.body).to match(/Video review already submitted/)
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
    let(:review) { create(:review, user: user, video: movie) }

    context 'When User is logged in' do
      before { login }
      context 'When review belongs to the User' do
        before { set_current_user(review.user) }
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
        before { set_current_user(create(:user)) }
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
