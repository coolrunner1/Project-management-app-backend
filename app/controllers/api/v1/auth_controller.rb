class Api::V1::AuthController < ApplicationController
    include JsonWebToken

    skip_before_action :authorize_request

    def login 
        login_value = params[:login].to_s

        user = if login_value.match?(/\A[^@\s]+@[^@\s]+\z/)
                User.find_by(email: login_value)
            else
                User.find_by(username: login_value)
            end

        if user&.authenticate(params[:password])
            token = encode_token(user_id: user.id, email: user.email)
            render json: { token: "Bearer #{token}", user: user.as_json(except: [:password_digest]) }, status: :ok
        else
            render json: { error: "Invalid login or password" }, status: :unauthorized
        end
    end

    def register
        user = User.new(register_params)

        if user.save
            if user&.authenticate(register_params[:password])
                token = encode_token(user_id: user.id, email: user.email)
                render json: { token: "Bearer #{token}", user: user.as_json(except: [:password_digest]) }, status: :ok
            else
                render json: { error: "Invalid login or password" }, status: :unauthorized
            end
        else 
            render json: user.errors, status: :unprocessable_entity
        end
    end

    private
    def register_params
        params.permit(:username, :email, :password)
    end
end
