class Api::V1::UsersController < ApplicationController
    def index
        @users = User.all
        
        render json: @users
    end
    def create
        user = User.create(user_params)
        if user.save 
            render json: user.as_json, status: :created
                    
        else 
            render json: user.errors, status: :unprocessable_entity
        end
    end
    def show
        user=User.find(params[:id])
        render json: user.as_json
    end
    def update
        
        if User.exists?(params[:id])
            user =User.find(params[:id])
            user.password_digest=params[:password_digest]
            user.save
            render json: user.as_json

        else
            error ={"message"=>"Could not find the user"}
            render json: error.as_json, status: :not_found
        end
    end
    def destroy
        if User.exists?(params[:id])
            user =User.find(params[:id])
            user.destroy
            render  status: :no_content
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
