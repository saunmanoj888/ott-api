require 'rails_helper'

RSpec.describe 'Users', type: :request do

  let(:signup_url) { '/api/v1/users' }
  let(:user) { create(:user) }

  describe 'POST /api/v1/users' do
    context 'when User Sign up with valid params' do
      before do
        post signup_url,
        params: user_params('john@example.com', 'password')
      end

      it 'returns 200' do
        expect(response).to have_http_status(201)
      end

      it 'creates a new user successfully' do
        expect(json['user']['email']).to eq('john@example.com')
      end
    end

    context 'when sign up params are incorrect' do
      context 'When User passes any required field as empty' do
        before do
          post signup_url,
          params: user_params('john@example.com', nil)
        end

        it 'returns validation failure message' do
          expect(response.body).to match(/Password can't be blank/)
          expect(response.status).to eq 400
        end
      end

      context 'When User enters email of existing user' do
        before do
          create(:user, email: 'john@example.com')
          post signup_url,
          params: user_params('john@example.com', 'password')
        end

        it 'returns validation failure message' do
          expect(response.body).to match(/Email has already been taken/)
          expect(response.status).to eq 400
        end
      end
    end
  end

  describe 'DELETE /api/v1/users/:id/remove_permission' do
    context 'When User is logged in' do

      context 'When User is Admin' do
        before { login(create(:user, :admin)) }

        context 'When Admin enters correct permission in params' do
          before { create(:permission, :create_review) }

          it 'removes the permissions successfully' do
            delete "/api/v1/users/#{user.id}/remove_permission", params: permission_argument('can_create_review')
            expect(response.body).to match(/Permission removed successfully/)
            expect(response.status).to eq 200
          end
        end

        context 'When Admin enters invalid permission in params' do
          it 'returns a not found error message' do
            delete "/api/v1/users/#{user.id}/remove_permission", params: permission_argument('incorrect_permission')
            expect(response.body).to match(/User does not have this permission assigned/)
            expect(response.status).to eq 404
          end
        end

        context 'When Admin enters permission which User does not have' do
          it 'returns a not found error message' do
            delete "/api/v1/users/#{user.id}/remove_permission", params: permission_argument('can_delete_rating')
            expect(response.body).to match(/User does not have this permission assigned/)
            expect(response.status).to eq 404
          end
        end
      end

      context 'When User is not Admin' do
        before { login(create(:user, :non_admin)) }

        it 'returns unauthorised failure message' do
          delete "/api/v1/users/#{user.id}/remove_permission", params: permission_argument('can_create_review')
          expect(response.body).to match(/You are not allowed to perform this action./)
          expect(response.status).to eq 401
        end
      end
    end

    context 'When User is logged out' do
      it 'returns a login failure message' do
        delete "/api/v1/users/#{user.id}/remove_permission", params: permission_argument('can_create_review')
        expect(response.body).to match(/Please log in/)
        expect(response.status).to eq 401
      end
    end
  end

  private

  def user_params(email, password)
    {
      user: {
        email:      email,
        password:   password,
        first_name: 'john',
        last_name:  'doe'
      }
    }
  end

  def permission_argument(value)
    { user: { permission: value } }
  end

end
