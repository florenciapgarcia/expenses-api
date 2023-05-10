# frozen_string_literal: true

class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token

  before_action :logged_in?, only: %i[show destroy]
  before_action :set_user, only: %i[show]
  # TODO: - the below should probably not be a public endpoint
  def index
    users = User.all
    render json: users
  end

  def create
    user = User.create(create_params)
    if user.save
      render json: { message: 'The user was created successfully.' }, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :bad_request
    end
  end

  def show
    if set_user
      render json: @user.show_user
    else
      head :unauthorized
    end
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

  def set_user
    @user = User.find(params[:id]) if params[:id].to_i == @current_user&.id
  end
end
