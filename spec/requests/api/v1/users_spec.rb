require 'rails_helper'

RSpec.describe 'Users', type: :request do

  let(:signup_url) { '/api/v1/users' }

  describe 'POST /api/v1/users' do
    context 'when User Sign up with valid params' do
      before do
        post signup_url,
        params: params('john@example.com', 'password')
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
          params: params('john@example.com', nil)
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
          params: params('john@example.com', 'password')
        end

        it 'returns validation failure message' do
          expect(response.body).to match(/Email has already been taken/)
          expect(response.status).to eq 400
        end
      end
    end
  end

  private

  def params(email, password)
    {
      user: {
        email:      email,
        password:   password,
        first_name: 'john',
        last_name:  'doe'
      }
    }
  end

end
