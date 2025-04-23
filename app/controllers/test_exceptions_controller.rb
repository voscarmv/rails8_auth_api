class TestExceptionsController < ApplicationController
    allow_unauthenticated_access
    skip_before_action
    skip_after_action

    def standard_error
      raise StandardError, "This is a StandardError for testing purposes"
    end

    def record_not_found
      raise ActiveRecord::RecordNotFound, "Record not found for testing purposes"
    end

    def parameter_missing
      raise ActionController::ParameterMissing, :example_param
    end
end
