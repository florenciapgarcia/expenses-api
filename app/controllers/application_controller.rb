# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing,
              with: :rescue_from_parameter_missing

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found_status

  private

  def rescue_from_parameter_missing(exception)
    render json: { message: exception.message }, status: :bad_request
  end

  def rescue_from_not_found_status(exception)
    render json: { message: exception.message }, status: :not_found
  end
end
