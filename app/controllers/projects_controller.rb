class ProjectsController < ApplicationController
  before_action :require_authentication
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    @projects = Current.user.projects.all
    render_success(
      message: "Projects loaded successfully.",
      data: { projects: @projects }
    )
  end

  # GET /projects/1
  def show
    render_success(
      message: "Project retrieved successfully.",
      data: { project: @project }
    )
  end

  # POST /projects
  def create
    @project = Current.user.projects.build(project_params)
    if @project.save
      render_success(
        message: "Project created successfully.",
        data: { project: @project },
        status: :created
      )
    else
      render_error(
        message: "Project creation failed.",
        errors: @project.errors,
        status: :unprocessable_entity
      )
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render_success(
        message: "Project updated successfully.",
        data: { project: @project }
      )
    else
      render_error(
        message: "Project update failed.",
        errors: @project.errors,
        status: :unprocessable_entity
      )
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    render_success(
      message: "Project deleted successfully.",
      data: {}
    )
  end

  private

  def set_project
    @project = Current.user.projects.find(params[:id])
  end

  def project_params
    params.expect(project: [ :title, :description, :user_id ])
  end
end
