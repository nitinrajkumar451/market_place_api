require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  #Todo get a better understanding on this let and creating objects
  let!(:users) { create_list(:user, 1) }
  let(:user_id) { users.first.id }
  describe "GET /index" do
    it 'should return all the users' do
      get '/api/v1/users'
      expect(response.status).to eq(200)      
      
    end

  end
  describe 'POST /users/' do

    let(:valid_attributes) do
      { email: 'alp1@ine.com', password_digest: 'password'}
      
    end
    context 'when request attributes are valid' do
      #Todo add check email already exists
      it 'returns status code 201' do
        post '/api/v1/users', params: valid_attributes
        expect(response).to have_http_status(201)
        
      end
      it 'returns the created object' do
        post '/api/v1/users', params: { email: 'alp1@ine.com', password_digest: 'password'}
        expected = JSON.parse(response.body)
        expected_email= expected["data"]["attributes"]["email"]
        expect(expected_email).to eq('alp1@ine.com')        
      end
      it 'returns the created object with an id as integer' do
        post '/api/v1/users', params: { email: 'alp1@ine.com', password_digest: 'password'}
        expected = JSON.parse(response.body)
        expected_id= expected["data"]["id"]  
        expect(expected_id.to_i).to be_a_kind_of(Integer)                   
      end
    end 
    context 'when request attributes are in-valid' do
      it 'returns status code 422' do 
        post '/api/v1/users', params: { email: 'alp1@ine.com', password_digest: ''}
        expect(response).to have_http_status(422)
      end
    end
  end
  describe 'GET /users/:id' do
    it 'returns the object with the queried id' do
      get "/api/v1/users/#{user_id}"
      expected = JSON.parse(response.body)
      expected_id = expected["data"]["id"]
      expect(expected_id.to_i).to be_a_kind_of(Integer)
      expect(expected_id.to_i).to eq(user_id)
    end
  end
  describe 'PUT /users/:id' do
    context 'when the user is authorized' do
      context 'when a user with the id exists' do
        it 'updates the user and returns the updated user' do
          post '/api/v1/users', params: { email: 'alp1@ine.com', password_digest: 'password'}
          put "/api/v1/users/2", params: {  password_digest: 'password1234'}, headers: { Authorization:
            JsonWebToken.encode(user_id: 2) }, as: :json
          expected = JSON.parse(response.body)
          expected_id= expected["data"]["id"]  
          expected_pwd= expected["password_digest"]  
          expect(expected_id.to_i).to be_a_kind_of(Integer)
          expect(expected_id.to_i).to eq(2)
          # expect(expected_pwd).to eq('password1234')
        end
      end
      context 'when a user with the id does not exist' do
        it 'returns status code 404' do
          put "/api/v1/users/200", params: {  password_digest: 'password123'}, headers: { Authorization:
            JsonWebToken.encode(user_id: 200) }, as: :json    
          expect(response).to have_http_status(404)        
        end
        it 'returns message could not find the user' do
          put "/api/v1/users/200", params: {  password_digest: 'password123'}, headers: { Authorization:
            JsonWebToken.encode(user_id: 1) }, as: :json      
          expected = JSON.parse(response.body) 
          expected_message= expected["message"]
          expect(expected_message).to eq("Could not find the user")        
        end
      end

    end
  end
  describe 'DELETE /users/:id' do
    context 'when the users is authorized' do          
      context 'and when the user with the id exists' do

        it 'returns a status code of 204' do
          delete '/api/v1/users/1', headers: { Authorization:
            JsonWebToken.encode(user_id: 1) }, as: :json
          expect(response).to have_http_status(204)
        end
      end
      context 'and when the user with id does not exist' do
        it 'returns a status code of 404' do
          delete '/api/v1/users/200', headers: { Authorization:
            JsonWebToken.encode(user_id: 1) }, as: :json
          expect(response).to have_http_status(404)

        end
      end
    end
    context 'when the user is not authorized' do
      let!(:user) { create(:user, email: 'abc@gmail.com', password_digest: "alp") }
      it 'returns a status code of 401' do
        delete '/api/v1/users/1', headers: { Authorization:
          JsonWebToken.encode(user_id: 2) }, as: :json
        expect(response).to have_http_status(401)
      end
    end
  end
end
