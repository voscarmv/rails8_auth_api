class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  skip_after_action :refresh_session, only: %i[ create destroy ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { data: "Try again later." } }

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      render json: { data: { token: Current.session.token  } }
    else
      render json: {}, status: :unauthorized
    end
  end

  # Optional: Implement destroy action for logging out
  def destroy
    Current.session.destroy
    head :no_content
  end
end
