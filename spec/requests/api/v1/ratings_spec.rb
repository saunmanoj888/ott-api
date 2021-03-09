require 'rails_helper'

RSpec.describe 'Ratings', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:non_admin_user) { create(:user, :non_admin) }
  let(:movie) { create(:movie) }
  let(:valid_params) { { rating: { value: 3 } } }

  describe 'GET /api/v1/movies/:movie_id/ratings' do
    context 'When User is logged in' do
      before do
        login(admin_user)
        create(:rating, user: admin_user, movie: movie)
      end

      it 'returns all ratings for the movie' do
        get "/api/v1/movies/#{movie.id}/ratings"
        expect(json).not_to be_empty
        expect(json['ratings'].size).to eq(1)
        expect(json['ratings'].first).to have_key('id')
        expect(response).to have_http_status(200)
      end
    end

    context 'When User is logged out' do
      it 'returns a failure message' do
        get "/api/v1/movies/#{movie.id}/ratings"
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/movies/:movie_id/ratings' do
    context 'When User is logged in' do
      before { login(admin_user) }

      context 'When User has not rated the movie yet' do
        it 'creates a new rating for the movie with valid attribute' do
          post "/api/v1/movies/#{movie.id}/ratings", params: valid_params
          expect(json['rating']['value']).to eq(3)
          expect(response).to have_http_status(201)
        end

        it 'returns a validation message with invalid attribute' do
          post "/api/v1/movies/#{movie.id}/ratings", params: { rating: { value: nil } }
          expect(response.body).to match(/Value can't be blank/)
          expect(response).to have_http_status(400)
        end
      end

      context 'When User has already rated the movie' do
        before { create(:rating, user: admin_user, movie: movie) }
        it 'does not allow to add rating again' do
          post "/api/v1/movies/#{movie.id}/ratings", params: valid_params
          expect(response.body).to match(/Movie rating already submitted/)
          expect(response).to have_http_status(400)
        end
      end
    end

    context 'When User is logged out' do
      it 'return a login failure message' do
        post "/api/v1/movies/#{movie.id}/ratings", params: valid_params
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /api/v1/ratings/:id' do
    let(:rating) { create(:rating, user: admin_user, movie: movie) }

    context 'When User is logged in' do
      context 'When rating belongs to the User' do
        before { login(rating.user) }
        it 'updates the rating successfully with valid attributes' do
          put "/api/v1/ratings/#{rating.id}", params: valid_params
          expect(json['rating']['value']).to eq(3)
          expect(response).to have_http_status(200)
        end
        it 'returns a validation message with invalid attributes' do
          put "/api/v1/ratings/#{rating.id}", params: { rating: { value: nil } }
          expect(response.body).to match(/Value can't be blank/)
          expect(response).to have_http_status(400)
        end
      end
      context 'When rating does not belongs to the User' do
        before { login(create(:user)) }
        it 'returns a unauthorised failure message' do
          put "/api/v1/ratings/#{rating.id}", params: valid_params
          expect(response.body).to match(/Not authorized to update Rating./)
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'When User is logged out' do
      it 'returns a login failure message' do
        put "/api/v1/ratings/#{rating.id}", params: valid_params
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end
end
