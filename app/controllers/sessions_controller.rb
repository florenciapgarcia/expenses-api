# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    return unless user

    if user.authenticate(params[:session][:password])
      reset_session
      log_in user
    else
      render json: { message: 'Your password is invalid. Please retry.' }, status: :unprocessable_entity
    end
  end

  def destroy
    # reset_session
  end

  private

  def create_params
    params.require(:session).permit(:email, :password)
  end
end
