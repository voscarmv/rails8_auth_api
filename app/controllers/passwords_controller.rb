class PasswordsController < ApplicationController
  allow_unauthenticated_access
  skip_after_action
  before_action :set_user_by_token, only: %i[update]

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_now
    end

    render_success(
      message: "Password reset instructions sent (if user with that email address exists).",
      data: {}
    )
  end

  def update
    if @user.update(password_params)
      render_success(
        message: "Password has been reset.",
        data: {}
      )
    else
      render_error(
        message: "Passwords did not match.",
        errors: @user.errors,
        status: :unprocessable_entity
      )
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render_error(
      message: "Password reset token is invalid or has expired.",
      status: :unprocessable_entity
    )
  end

  def password_params
    params.expect(password: [ :password, :password_confirmation ])
  end
end
