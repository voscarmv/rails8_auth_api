class ApplicationController < ActionController::API
  include Authentication
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from StandardError, with: :handle_internal_server_error

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

  private

  def handle_record_not_found(exception)
    render_error(
      message: "Record not found",
      errors: { detail: exception.message },
      status: :not_found
    )
  end

  def handle_parameter_missing(exception)
    render_error(
      message: "Missing parameter",
      errors: { detail: exception.message },
      status: :bad_request
    )
  end

  def handle_internal_server_error(exception)
    render_error(
      message: "Internal server error",
      errors: { detail: exception.message },
      status: :internal_server_error
    )
  end
end
