class Api::V1::ProjectsController < ApplicationController
    before_action :set_project, only: %i[ show update destroy ]

    def index
        @projects = Project.where("user_id = ?", @current_user.id)
        render json: @projects
    end

    def show
        render json: @project
    end

    def create
        @project = Project.new(project_params.merge(user_id: @current_user.id))

        if @project.save
            render json: @project, status: :created
        else 
            render json: @project.errors, status: :unprocessable_entity
        end
    end

    def update
        if @project.update(project_params)
            render json: @project
        else
            render json: @project.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if @project
            @project.destroy
        end
    end

    private
    def set_project
        @project = Project.find_by(id: params[:id], user_id: @current_user.id)
        unless @project
            render json: {"error": "not found"}, status: :not_found
        end
    end

    def project_params
        params.permit(:title, :description)
    end
end