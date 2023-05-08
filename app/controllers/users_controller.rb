# frozen_string_literal: true

class UsersController < ApplicationController
  # TODO: - the below should probably not be a public endpoint
  def index
    users = User.all
    render json: users
  end

  def create
    user = User.create(create_params)
    puts user.inspect
    render json: { message: 'The user was created successfully.' }, status: :created
  end

  private

  def create_params
    params
      .require(:user)
      .permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation
      )
      .tap do |user_params|
      user_params.require(:first_name)
      user_params.require(:last_name)
      user_params.require(:email)
      user_params.require(:password)
      user_params.require(:password_confirmation)
    end
  end
end
