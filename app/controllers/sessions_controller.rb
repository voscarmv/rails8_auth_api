class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[create]
  skip_after_action :refresh_session, only: %i[create destroy]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    render_error(
      message: "Too many login attempts. Try again later.",
      status: :too_many_requests
    )
  }

  def create
    if user = User.authenticate_by(session_params)
      start_new_session_for user
      render_success(
        message: "Login successful.",
        data: { token: Current.session.token }
      )
    else
      render_error(
        message: "Invalid email or password.",
        status: :unauthorized
      )
    end
  end

  # Optional: Implement destroy action for logging out
  def destroy
    Current.session.destroy
    render_success(
      message: "Logout successful.",
      data: {},
      status: :ok
    )
  end

  private

  def session_params
    params.expect(user: [:email_address, :password])
  end
end
