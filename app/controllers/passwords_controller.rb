class PasswordsController < ApplicationController
  allow_unauthenticated_access
  skip_after_action
  before_action :set_user_by_token, only: %i[ edit update ]
  before_action :require_admin, only: [:update]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_now
    end

    render json: { data: "Password reset instructions sent (if user with that email address exists)." }
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      render json: { data: "Password has been reset." } 
    else
      render json: { data: "Passwords did not match." }, status: :unprocessable_entity
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      render json: { data: "Password reset link is invalid or has expired." }, status: :unprocessable_entity
    end
end
