class Api::V1::TokensController < ApplicationController
    def create
        if(User.exists?(email: params[:email]))
            @user = User.find_by_email(params[:email])
            password = @user.password_digest
            if valid_password(params[:password_digest],password)
                render json: {
                    token: JsonWebToken.encode(user_id: @user.id),
                    email: @user.email
                }
            else
                render status: :unauthorized
            end
        else
            render status: :not_found
        end
    end
    private
    def valid_password(entered_password, existing_password)
        if entered_password==existing_password
            return true
        else
            return false
        end
    end
end
