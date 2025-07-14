class Api::V1::ProjectsController < ApplicationController
    before_action :set_project, only: %i[ show update destroy ]

    def index
        @projects = Project.where("user_id = ?", 1)
        render json: @projects
    end

    def show
        if @project
            render json: @project
        else 
            render json: {"error": "not found"}, status: :not_found
        end
    end

    def create
        @project = Project.new(project_params.merge(user_id: 1))

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
        else 
            render json: {"error": "not found"}, status: :not_found
        end
    end

    private
    def set_project
        @project = Project.find_by(id: params[:id], user_id: 1)
    end

    def project_params
        params.permit(:title, :description)
    end
end