class ApplicationController < ActionController::API
  include Authentication

  # Used for JSON API response formatting
  def render_success(message:, data: {}, status: :ok)
    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end

  def render_error(message:, errors: {}, status: :unprocessable_entity)
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end

  # Example: Add common error handling if needed
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(
      message: "Record not found.",
      errors: { detail: exception.message },
      status: :not_found
    )
  end

  rescue_from StandardError do |exception|
    logger.error "[500] #{exception.class} - #{exception.message}"
    logger.error exception.backtrace.join("\n") if Rails.env.development?

    render_error(
      message: "An unexpected error occurred.",
      errors: { detail: exception.message },
      status: :internal_server_error
    )
  end
end
