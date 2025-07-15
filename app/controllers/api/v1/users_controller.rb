class Api::V1::UsersController < ApplicationController
    before_action :set_user, only: %i[ show update destroy ]

    def index
        @users = User.all
        render json: @users
    end

    def show
        if @user
            render json: @user
        else 
            render json: {"error": "not found"}, status: :not_found
        end
    end

    def create
        print user_params
        @user = User.new(user_params)

        if @user.save
            render json: @user, status: :created
        else 
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def update
        if @user.update(user_params.except(:password))
            if user_params[:password].present?
                @user.update(password: user_params[:password])
            end
            render json: @user
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if @user
            @user.destroy
        else 
            render json: {"error": "not found"}, status: :not_found
        end
    end

    private
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.permit(:username, :email, :password)
    end
end
