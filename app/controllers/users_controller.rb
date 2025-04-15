class UsersController < ApplicationController
    before_action :require_authentication
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :require_admin, only: [:index, :update, :create, :destroy]
  
    def index
      users = User.all
      render json: users
    end
  
    def show
      render json: @user
    end
  
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def create
        user = User.new(user_params)

        if user.save
          render json: { message: 'User created', user: user }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    def destroy
      @user.destroy
      head :no_content
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end
  
    def user_params
      params.require(:user).permit(:email_address, :password, :role)
    end
  
    def require_admin
      unless Current.user&.role == 'admin'
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end
end
