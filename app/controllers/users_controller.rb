class UsersController < ApplicationController
  before_action :require_authentication
  before_action :set_user, only: [ :show, :update, :destroy ]
  before_action :require_admin, only: [ :index, :update, :create, :destroy ]

  def index
    users = User.all
    render_success(
      message: "Users loaded successfully.",
      data: { users: users }
    )
  end

  def show
    render_success(
      message: "User retrieved successfully.",
      data: { user: @user }
    )
  end

  def update
    if @user.update(user_params)
      render_success(
        message: "User updated successfully.",
        data: { user: @user }
      )
    else
      render_error(
        message: "User update failed.",
        errors: @user.errors.full_messages,
        status: :unprocessable_entity
      )
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render_success(
        message: "User created successfully.",
        data: { user: user },
        status: :created
      )
    else
      render_error(
        message: "User creation failed.",
        errors: user.errors.full_messages,
        status: :unprocessable_entity
      )
    end
  end

  def destroy
    @user.destroy
    render_success(
      message: "User deleted successfully.",
      data: {}
    )
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error(
      message: "User not found.",
      status: :not_found
    )
  end

  def user_params
    params.expect(user: [ :email_address, :password, :role ])
  end
end
