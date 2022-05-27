require 'rails_helper'

RSpec.describe "Concerns", type: :controller do

    class MockController
        include Authenticable
        attr_accessor :request
        def initialize
          mock_request = Struct.new(:headers)
          self.request = mock_request.new({})
        end
    end

    # let!(:users) { create_list(:user, 1) }

    # @user = User.new("email":"nitin@incubyte.co","password_digest":"alpha")
    before { @user = User.create("email":"nitin@incubyte.co","password_digest":"alpha")
        @authentication = MockController.new}
    it "fetches user from authentication token" do
        # @authentication.request.headers['Authorization']
        # puts @user.
        @authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: @user.id)
        # puts @authentication
        # puts @authentication.current_user.id
        expect(@authentication.current_user.id).not_to eq(nil)
        expect(@authentication.current_user.id).to eq(@user.id)
    end
    
end