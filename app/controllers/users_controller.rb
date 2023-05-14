# frozen_string_literal: true

class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token

  before_action :logged_in?, only: %i[show destroy]
  before_action :set_user, only: %i[show destroy]

  def index
    users = User.user_data.map do |user|
      { id: user[0], first_name: user[1], last_name: user[2], email: user[3] }
    end
    render json: users
  end

  def create
    user = User.new(create_params)

    if user.save
      render json: { message: 'The user was created successfully.' }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    if set_user
      render json: @user.show_user
    else
      head :unauthorized
    end
  end

  def update; end

  def destroy
    if set_user
      @user.destroy
      render json: { message: 'The user was deleted successfully.' }
    else
      head :unauthorized
    end
  end

  private

  def create_params
    params.require(:user).permit(:first_name, :last_name, :email)
          .tap do |user_params|
            user_params.require(:first_name)
            user_params.require(:last_name)
            user_params.require(:email)
            user_params[:password] = params[:password]
            user_params[:password_confirmation] = params[:password_confirmation]
          end
  end

  def set_user
    @user = User.find(params[:id]) if params[:id].to_i == @current_user&.id
  end
end
