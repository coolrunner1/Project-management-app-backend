class Api::V1::ProfileController < ApplicationController
    def show
        render json: @current_user.as_json(except: [:password_digest]) 
    end

    def update
        if @current_user.update(user_params.except(:password))
            if user_params[:password].present?
                @current_user.update(password: user_params[:password])
            end
            render json: @current_user.as_json(except: [:password_digest])
        else
            render json: @current_user.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @current_user.destroy
    end

    def user_params
        params.permit(:username, :email, :password)
    end
end
