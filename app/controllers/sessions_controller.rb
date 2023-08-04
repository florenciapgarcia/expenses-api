# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :logged_in?, only: %i[destroy]
  include SessionsHelper
  skip_before_action :verify_authenticity_token, only: %i[destroy create]

  def create
    user = User.find_by(email: create_params[:email])
    if missing_params?(create_params)
      head :bad_request
    elsif user&.authenticate(create_params[:password])
      reset_session
      log_in user
      head :ok
    else
      render json: { message: 'Your password is invalid. Please retry.' }, status: :unauthorized
    end
  end

  def destroy
    if logged_in?
      log_out
      render json: { message: 'You have logged out successfully.' }
    else
      head :bad_request
    end
  end

  private

  def create_params
    params
      .require(:session)
      .permit(:email, :password)
      .tap do |session_params|
        session_params.require(:email)
        session_params.require(:password)
      end
  end
end
