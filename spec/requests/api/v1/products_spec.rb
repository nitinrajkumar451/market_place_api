require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  describe 'GET /products/:id' do
    it 'returns the product with the queried id' do
      get "/api/v1/products/#{product.id}"
      expected = JSON.parse(response.body)
      expected_id = expected["id"]
      expect(expected_id).to be_a_kind_of(Integer)
      expect(expected_id).to eq(product.id)
    end
  end
  describe "GET /index" do
    it 'should return all the products' do
      get '/api/v1/products'
      expect(response.status).to eq(200)        
    end
  end
  describe 'POST /users/' do
    let(:valid_attributes) do
      { email: 'alp1@ine.com', password_digest: 'password'}      
    end
    context 'when request attributes including user are valid' do
      it 'returns status code 201' do
        post '/api/v1/products', params: { product: { title: "alp", price:
          100, published: true } }, headers: { Authorization:
            JsonWebToken.encode(user_id: product.user_id) }, as: :json
        expect(response).to have_http_status(201)
        expected = JSON.parse(response.body)
        expected_email= expected["title"]
        id= expected["id"]
        expect(expected_email).to eq('alp')    
        expect(id).to eq(2)            
      end
    end
    context 'when request attributes in valid or user is not provided' do
      it 'returns status code 422' do
        post '/api/v1/products', params: { product: { title: "alp", price:
          100, published: true } }
        expect(response).to have_http_status(403)        
      end    
    end 
  end
  describe 'PUT /products/:id' do
    context 'when the user is authorized' do
      context 'when a user with the id exists' do
        it 'updates the user and returns the updated user' do
          post '/api/v1/products', params: { product: { title: "alp", price:
            100, published: true } }, headers: { Authorization:
              JsonWebToken.encode(user_id: product.user_id) }, as: :json
          put "/api/v1/products/2", params: {  title: 'password1234'}, headers: { Authorization:
            JsonWebToken.encode(user_id: 2) }, as: :json
          expected = JSON.parse(response.body)
          expected_id= expected["id"]  
          expected_pwd= expected["title"]  
          expect(expected_id).to be_a_kind_of(Integer)
          expect(expected_id).to eq(2)
          expect(expected_pwd).to eq('password1234')
        end
      end
    end
  end
  describe 'DELETE /products/:id' do
    context 'when the users is authorized' do          
      context 'and when the product with the id exists' do

        it 'returns a status code of 204' do
          delete '/api/v1/products/1', headers: { Authorization:
            JsonWebToken.encode(user_id: 1) }, as: :json
          expect(response).to have_http_status(204)
        end
      end      
    end    
  end
end
