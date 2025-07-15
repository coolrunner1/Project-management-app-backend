class Api::V1::TasksController < ApplicationController
    before_action :set_task, only: %i[ show update destroy ]

    def index
        @tasks = Task.where("project_id = ?", params[:project_id])

        @tasks = @tasks.where(status: params[:status]) if params[:status].present?

        if params[:createdAt] == "desc"
            @tasks = @tasks.order(created_at: :desc)
        else
            @tasks = @tasks.order(created_at: :asc)
        end

        if params[:updatedAt] == "desc"
            @tasks = @tasks.order(updated_at: :desc)
        else
            @tasks = @tasks.order(updated_at: :asc)
        end

        render json: @tasks
    end

    def show
        if @task
            render json: @task
        else 
            render json: {"error": "not found"}, status: :not_found
        end
    end

    def create
        @task = Task.create(
            title: task_params[:title],
            description: task_params[:description],
            project_id: params[:project_id],
            status: "to_do"
            )

        if @task.save
            render json: @task, status: :created
        else 
            render json: @task.errors, status: :unprocessable_entity
        end
    end

    def update
        allow_status_update = false
        if @task.update(task_params.except(:status))
            status = task_params[:status]
            print status
            if status
                if @task.status == "to_do" && status == "in_progress"
                    allow_status_update = true
                elsif @task.status == "in_progress" && (status == "in_testing" || status == "to_do")
                    allow_status_update = true
                elsif @task.status == "in_testing" && (status == "done" || status == "rejected")
                    allow_status_update = true
                elsif @task.status == "rejected" && status == "in_progress"
                    allow_status_update = true
                end
                if allow_status_update
                    @task.update(status: task_params[:status])
                end
            end
            render json: @task
        else
            render json: @task.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if @task
            @task.destroy
        else 
            render json: {"error": "not found"}, status: :not_found
        end
    end

    private
    def set_task
        @task = Task.find_by(id: params[:id], project_id: params[:project_id])
    end

    def task_params
        params.permit(:title, :description, :status)
    end
end
