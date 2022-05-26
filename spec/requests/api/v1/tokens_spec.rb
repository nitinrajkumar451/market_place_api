require 'rails_helper'

RSpec.describe "Api::V1::Tokens", type: :request do
  let!(:users) { create_list(:user, 1) }
  let(:user_id) { users.first.id }
  describe "POST /tokens" do
    context 'accepts a valid email and password' do
      it 'returns token' do
        post '/api/v1/users', params: { email: 'alp1@ine.com', password_digest: 'password'}
        post '/api/v1/tokens', params: { email: 'alp1@ine.com', password_digest: 'password'}
        output = response.body
        output_token = output["token"]
        expect(output_token).not_to be_empty
      end
    end
    context 'accepts an invalid email and password' do      
      it 'returns 403 when password is empty' do
        post '/api/v1/users', params: { email: 'alp1@ine.com', password_digest: 'password'}
        post '/api/v1/tokens', params: { email: 'alp1@ine.com', password_digest: 'pass'}
        expect(response).to have_http_status(401)
      end
      it 'returns 404 when email is not found' do
        post '/api/v1/tokens', params: { email: 'alp1@ine.com', password_digest: ''}
        post '/api/v1/tokens', params: { email: 'alp2@ine.com', password_digest: ''}
        expect(response).to have_http_status(404)
      end      
    end    

  end
end
