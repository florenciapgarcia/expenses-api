# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    if params[:session].blank?
      render json: { message: 'Sign in with your credentials.' }, status: :unauthorized
    else
      user = User.find_by(email: params[:session][:email])
      if user&.authenticate(params[:session][:password])
        reset_session
        log_in user
        render json: { message: "Welcome, #{user.full_name}" }
      else
        render json: { message: 'Your password is invalid. Please retry.' }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    log_out
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
