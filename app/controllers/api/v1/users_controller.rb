class Api::V1::UsersController < ApplicationController
    before_action :check_owner, only: %i[update destroy]
    def index
        @users = User.all
        
        render json: @users
    end
    def create
        user = User.create(user_params)
        if user.save 
            render json: UserSerializer.new(user).serializable_hash.to_json, status: :created
                    
        else 
            render json: user.errors, status: :unprocessable_entity
        end
    end
    def show

        user=User.find(params[:id])
        options = { include: [:products] }
        render json: UserSerializer.new(user, options).serializable_hash.to_json, status: :created
    end
    def update        
        user =User.find(params[:id])
        user.password_digest=params[:password_digest]
        user.save
        render json: UserSerializer.new(user).serializable_hash.to_json
    end
    def destroy

        user =User.find(params[:id])
        user.destroy
        error ={"message"=>"Could not find the user"}
        render json: error.as_json, status: :no_content


    end
    private 
    def check_owner
        if User.exists?(params[:id])
            @user =User.find(params[:id])
            head :unauthorized unless @user.id == current_user&.id
        else
            error ={"message"=>"Could not find the user"}
            render json: error.as_json, status: :not_found
        end
    end
    private
    def user_params
        params.permit(:email, :password_digest)
    end
    # def set_book
    #   @book = Book.find(params[:id])
    # end
end
