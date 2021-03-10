require 'rails_helper'

RSpec.describe 'Ratings', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:non_admin_user) { create(:user, :non_admin) }
  let(:rating_by_admin) { create(:rating, user: admin_user) }
  let(:rating_by_non_admin) { create(:rating, user: non_admin_user) }
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

  describe 'DELETE /api/v1/ratings/:id' do
    context 'When User is logged in' do
      context 'When Record Exists' do
        context 'When User is admin' do
          before { login(admin_user) }
          context 'When Admin is not blocked' do
            context 'When rating belongs to the Admin' do
              it 'deletes the rating successfully' do
                delete "/api/v1/ratings/#{rating_by_admin.id}"
                expect(response.body).to match(/Rating destroyed successfully/)
                expect(response).to have_http_status(200)
              end
            end
            context 'When rating does not belongs to the Admin' do
              it 'deletes the rating successfully' do
                delete "/api/v1/ratings/#{rating_by_non_admin.id}"
                expect(response.body).to match(/Rating destroyed successfully/)
                expect(response).to have_http_status(200)
              end
            end
          end

          context 'When Admin is blocked' do
            context 'When rating belongs to the Admin' do
              it 'unable to delete the rating' do
              end
            end
            context 'When rating does not belongs to Admin' do
              it 'unable to delete the rating' do
              end
            end
          end
        end

        context 'When User is not admin' do
          before { login(non_admin_user) }
          context 'When User is not blocked' do
            context 'When rating belongs to the User' do
              it 'unable to delete the rating' do
                delete "/api/v1/ratings/#{rating_by_non_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Rating/)
                expect(response).to have_http_status(401)
              end
            end
            context 'When rating does not belongs to the User' do
              it 'unable to delete the rating' do
                delete "/api/v1/ratings/#{rating_by_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Rating/)
                expect(response).to have_http_status(401)
              end
            end
          end

          context 'When User is blocked' do
            context 'When rating belongs to the User' do
              it 'unable to delete the rating' do
              end
            end
            context 'When rating does not belongs to User' do
              it 'unable to delete the rating' do
              end
            end
          end
        end
      end

      context 'When Record does not Exist' do
        before { login(admin_user) }
        it 'returns a not found message' do
          delete '/api/v1/ratings/101'
          expect(response.body).to match(/Couldn't find Rating/)
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'When User is logged out' do
      it 'returns a login failure message' do
        delete "/api/v1/ratings/#{rating_by_admin.id}"
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end
end
