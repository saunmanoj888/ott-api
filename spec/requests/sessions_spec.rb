require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }
  let(:login_url) { '/api/v1/sessions' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  describe 'POST /api/v1/sessions' do
    context 'when login credentials are correct' do
      before { post login_url, params: params }

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns valid JWT token along with User details' do
        expect(json['user']['email']).to eq(user.email)
        expect(json['token']).to be_present
      end
    end

    context 'when login params are incorrect' do
      before { post login_url }

      it 'returns unathorized status' do
        expect(response.status).to eq 401
      end
    end

    context 'when login credentials are incorrect' do
      before { post login_url, params: { user: { email: user.email, password: nil }} }

      it 'returns unathorized status' do
        expect(response.status).to eq 401
      end
    end
  end

end
