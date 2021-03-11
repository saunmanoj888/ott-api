require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:non_admin_user) { create(:user, :non_admin) }
  let(:review_by_admin) { create(:review, user: admin_user) }
  let(:review_by_non_admin) { create(:review, user: non_admin_user) }
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
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/movies/:movie_id/reviews' do
    before { create(:permission, :create_review) }
    context 'When User is logged in' do
      before { login(admin_user) }
      context 'When User has the permission to create a review' do
        context 'When User has not reviewed the movie yet' do
          it 'creates a new review for the movie with valid attribute' do
            post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
            expect(json['review']['body']).to eq('Must watch')
            expect(response).to have_http_status(201)
          end

          it 'returns a validation message with invalid attribute' do
            post "/api/v1/movies/#{movie.id}/reviews", params: { review: { body: nil } }
            expect(response.body).to match(/Body can't be blank/)
            expect(response).to have_http_status(400)
          end
        end

        context 'When User has already reviewed the movie' do
          before { create(:review, user: admin_user, movie: movie) }
          it 'does not allow to add review again' do
            post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
            expect(response.body).to match(/Movie review already submitted/)
            expect(response).to have_http_status(400)
          end
        end
      end
      context 'When User does not have permission to create a review' do
        before { admin_user.permissions.destroy(Permission.find_by(name: 'can_create_review')) }
        it 'returns unauthorized failure message' do
          post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
          expect(response.body).to match(/Not authorized to create Review/)
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'When User is logged out' do
      it 'return a login failure message' do
        post "/api/v1/movies/#{movie.id}/reviews", params: valid_params
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /api/v1/reviews/:id' do
    before { create(:permission, :edit_review) }
    context 'When User is logged in' do
      context 'When Record Exists' do
        context 'When User is admin' do
          before { login(admin_user) }
          context 'When Admin has permission to update reviews' do
            context 'When review belongs to the Admin' do
              it 'updates the review successfully with valid params' do
                put "/api/v1/reviews/#{review_by_admin.id}", params: valid_params
                expect(json['review']['body']).to eq('Must watch')
                expect(response).to have_http_status(200)
              end

              it 'returns validation failure message with invalid params' do
                put "/api/v1/reviews/#{review_by_admin.id}", params: { review: { body: nil } }
                expect(response.body).to match(/Body can't be blank/)
                expect(response).to have_http_status(400)
              end
            end
            context 'When review does not belongs to the Admin' do
              it 'unable to update the review' do
                put "/api/v1/reviews/#{review_by_non_admin.id}", params: valid_params
                expect(response.body).to match(/Not authorized to update Review/)
                expect(response).to have_http_status(401)
              end
            end
          end

          context 'When Admin does not have permission to update reviews' do
            before { admin_user.permissions.destroy(Permission.find_by(name: 'can_edit_review')) }
            context 'When review belongs to the Admin' do
              it 'unable to update the review' do
                put "/api/v1/reviews/#{review_by_admin.id}", params: valid_params
                expect(response.body).to match(/Not authorized to update Review/)
                expect(response).to have_http_status(401)
              end
            end
            context 'When review does not belongs to Admin' do
              it 'unable to update the review' do
                put "/api/v1/reviews/#{review_by_non_admin.id}", params: valid_params
                expect(response.body).to match(/Not authorized to update Review/)
                expect(response).to have_http_status(401)
              end
            end
          end
        end

        context 'When User is not admin' do
          before { login(non_admin_user) }
          context 'When User has permission to update ratings' do
            context 'When review belongs to the User' do
              it 'updates the review successfully' do
                put "/api/v1/reviews/#{review_by_non_admin.id}", params: valid_params
                expect(json['review']['body']).to eq('Must watch')
                expect(response).to have_http_status(200)
              end
            end
            context 'When review does not belongs to the User' do
              it 'unable to update the review' do
                put "/api/v1/reviews/#{review_by_admin.id}", params: valid_params
                expect(response.body).to match(/Not authorized to update Review/)
                expect(response).to have_http_status(401)
              end
            end
          end

          context 'When User does not have permission to update reviews' do
            before { non_admin_user.permissions.destroy(Permission.find_by(name: 'can_edit_review')) }
            context 'When review belongs to the User' do
              it 'unable to update the review' do
                put "/api/v1/reviews/#{review_by_admin.id}", params: valid_params
                expect(response.body).to match(/Not authorized to update Review/)
                expect(response).to have_http_status(401)
              end
            end
            context 'When review does not belongs to User' do
              it 'unable to update the review' do
                put "/api/v1/reviews/#{review_by_non_admin.id}", params: valid_params
                expect(response.body).to match(/Not authorized to update Review/)
                expect(response).to have_http_status(401)
              end
            end
          end
        end
      end

      context 'When Record does not Exist' do
        before { login(admin_user) }
        it 'returns a not found message' do
          put '/api/v1/reviews/101', params: valid_params
          expect(response.body).to match(/Couldn't find Review/)
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'When User is logged out' do
      it 'returns a login failure message' do
        put "/api/v1/reviews/#{review_by_non_admin.id}", params: valid_params
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/reviews/:id' do
    before { create(:permission, :delete_review) }
    context 'When User is logged in' do
      context 'When Record Exists' do
        context 'When User is admin' do
          before { login(admin_user) }
          context 'When Admin has permission to delete reviews' do
            context 'When review belongs to the Admin' do
              it 'deletes the review successfully' do
                delete "/api/v1/reviews/#{review_by_admin.id}"
                expect(response.body).to match(/Review destroyed successfully/)
                expect(response).to have_http_status(200)
              end
            end
            context 'When review does not belongs to the Admin' do
              it 'deletes the review successfully' do
                delete "/api/v1/reviews/#{review_by_non_admin.id}"
                expect(response.body).to match(/Review destroyed successfully/)
                expect(response).to have_http_status(200)
              end
            end
          end

          context 'When Admin does not have permission to delete reviews' do
            before { admin_user.permissions.destroy(Permission.find_by(name: 'can_delete_review')) }
            context 'When review belongs to the Admin' do
              it 'unable to delete the review' do
                delete "/api/v1/reviews/#{review_by_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Review./)
                expect(response).to have_http_status(401)
              end
            end
            context 'When review does not belongs to Admin' do
              it 'unable to delete the review' do
                delete "/api/v1/reviews/#{review_by_non_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Review./)
                expect(response).to have_http_status(401)
              end
            end
          end
        end

        context 'When User is not admin' do
          before { login(non_admin_user) }
          context 'When User has permission to delete reviews' do
            context 'When review belongs to the User' do
              it 'deletes the review successfully' do
                delete "/api/v1/reviews/#{review_by_non_admin.id}"
                expect(response.body).to match(/Review destroyed successfully/)
                expect(response).to have_http_status(200)
              end
            end
            context 'When review does not belongs to the User' do
              it 'unable to delete the review' do
                delete "/api/v1/reviews/#{review_by_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Review/)
                expect(response).to have_http_status(401)
              end
            end
          end

          context 'When User does not have permission to delete reviews' do
            before { non_admin_user.permissions.destroy(Permission.find_by(name: 'can_delete_review')) }
            context 'When review belongs to the User' do
              it 'unable to delete the review' do
                delete "/api/v1/reviews/#{review_by_non_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Review/)
                expect(response).to have_http_status(401)
              end
            end
            context 'When review does not belongs to User' do
              it 'unable to delete the review' do
                delete "/api/v1/reviews/#{review_by_admin.id}"
                expect(response.body).to match(/Not authorized to destroy Review/)
                expect(response).to have_http_status(401)
              end
            end
          end
        end
      end

      context 'When Record does not Exist' do
        before { login(admin_user) }
        it 'returns a not found message' do
          delete '/api/v1/reviews/101'
          expect(response.body).to match(/Couldn't find Review/)
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'When User is logged out' do
      it 'returns a login failure message' do
        delete "/api/v1/reviews/#{review_by_admin.id}"
        expect(response.body).to match(/Please log in/)
        expect(response).to have_http_status(401)
      end
    end
  end
end
