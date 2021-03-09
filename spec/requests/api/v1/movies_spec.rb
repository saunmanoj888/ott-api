require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:non_admin_user) { create(:user, :non_admin) }
  let!(:movie) { create(:movie) }

  describe 'GET /api/v1/movies' do
    context 'When User is logged in' do
      before { login(admin_user) }

      it 'returns all available movies with status code 200' do
        get '/api/v1/movies'
        expect(json).not_to be_empty
        expect(json['movies'].size).to eq(1)
        expect(json['movies'].first).to have_key('id')
        expect(response).to have_http_status(200)
      end
    end

    context 'When User is not logged in' do
      it 'returns a failure message' do
        get '/api/v1/movies'
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/movies/:id' do
    context 'When User is logged in' do
      before { login(admin_user) }

      context 'When record exists' do
        it 'returns the movie with status code 200' do
          get "/api/v1/movies/#{movie.id}"
          expect(json['movie']).not_to be_empty
          expect(json['movie']).to have_key('id')
          expect(response).to have_http_status(200)
        end
      end

      context 'When record does not exists' do
        it 'returns a not found message' do
          get '/api/v1/movies/500'
          expect(response.body).to match(/Couldn't find Movie/)
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'When User is not logged in' do
      it 'returns a failure message' do
        get '/api/v1/movies/1'
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/movies' do
    let(:valid_attributes) { { movie: { title: 'Saw', description: 'horror', release_date: '01-01-2020', budget: 10000 } } }

    context 'When User is logged in' do
      context 'When User is Admin' do
        before { login(admin_user) }

        it 'creates a movie with valid attributes' do
          post '/api/v1/movies', params: valid_attributes
          expect(json['movie']['title']).to eq('Saw')
          expect(response).to have_http_status(201)
        end

        it 'returns validation message with invalid attributes' do
          post '/api/v1/movies', params: { movie: { title: nil } }
          expect(response.body).to match(/Title can't be blank/)
          expect(response).to have_http_status(400)
        end
      end
      context 'When User is not Admin' do
        before { login(non_admin_user) }

        it 'returns an unauthorised failure messages' do
          post '/api/v1/movies', params: valid_attributes
          expect(response.body).to match(/Not authorized to create Movie/)
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'When User is not logged in' do
      it 'returns a login failure message' do
        post '/api/v1/movies', params: valid_attributes
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /api/v1/movies/:id' do
    let(:valid_attributes) { { movie: { title: 'Saw Updated' } } }

    context 'When User is logged in' do
      context 'When User is Admin' do
        before { login(admin_user) }

        it 'updates a movie with valid attributes' do
          put "/api/v1/movies/#{movie.id}", params: valid_attributes
          expect(json['movie']['title']).to eq('Saw Updated')
          expect(response).to have_http_status(200)
        end

        it 'returns validation message with invalid attributes' do
          put "/api/v1/movies/#{movie.id}", params: { movie: { title: nil } }
          expect(response.body).to match(/Title can't be blank/)
          expect(response).to have_http_status(400)
        end
      end
      context 'When User is not Admin' do
        before { login(non_admin_user) }

        it 'returns an unauthorised failure messages' do
          put "/api/v1/movies/#{movie.id}", params: valid_attributes
          expect(response.body).to match(/Not authorized to update Movie/)
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'When User is not logged in' do
      it 'returns a login failure message' do
        put "/api/v1/movies/#{movie.id}", params: valid_attributes
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/movies/:id' do
    context 'When User is logged in' do

      context 'When User is Admin' do
        before { login(admin_user) }

        it 'deletes a movie successfully' do
          delete "/api/v1/movies/#{movie.id}"
          expect(json['message']).to eq('Movie destroyed successfully')
          expect(response).to have_http_status(200)
        end
      end

      context 'When User is not Admin' do
        before { login(non_admin_user) }

        it 'returns an unauthorised failure messages' do
          delete "/api/v1/movies/#{movie.id}"
          expect(response.body).to match(/Not authorized to destroy Movie/)
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'When User is not logged in' do
      it 'returns a login failure message' do
        delete "/api/v1/movies/#{movie.id}"
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end
end
