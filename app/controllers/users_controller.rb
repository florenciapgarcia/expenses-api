# frozen_string_literal: true

# TODO: - create BaseController and add logged_in, and set_user
class UsersController < ApplicationController
  before_action :logged_in?, only: %i[show destroy update]
  before_action :set_user, only: %i[show destroy update]
  skip_before_action :verify_authenticity_token, only: %i[destroy create update]

  # TODO: - delete below
  def index
    render json: User.all
  end

  # TODO: - add that when user is created, a new session starts with session[:user_id] - add it to tests

  def create
    user = User.new(create_params)

    if user.save!
      render json: { message: 'The user was created successfully.' }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    render json: @user
  end

  def update
    @user.update!(update_params)
    render json: @user.reload
  end

  def destroy
    @user.destroy!
    render json: { message: 'The user was deleted successfully.' }
  end

  private

  def create_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
          .tap do |user_params|
      user_params.require(:first_name)
      user_params.require(:last_name)
      user_params.require(:email)
      user_params.require(:password)
      user_params.require(:password_confirmation)
    end
  end

  def update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(params[:id]) if params[:id].to_i == @current_user&.id
    return unless @user.nil?

    head :unauthorized
  end
end
