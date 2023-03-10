class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing,
              with: :rescue_from_parameter_missing

  private

  def rescue_from_parameter_missing(exception)
    render json: { message: exception.message }, status: :bad_request
  end
end
