# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show destroy]
  before_action :set_user, only: %i[index create show destroy update]
  skip_before_action :verify_authenticity_token, only: [:destroy, :create]

  include SessionsHelper

  def index
    puts 'USER*****: ', @user&.id.class
    puts  params[:user_id].class
    if @user&.id.nil? || @user.id != params[:user_id].to_i
      render json: { error: "You're not authorised see these expenses." }, status: :unauthorized
    else
      expenses = Expense.where(user_id: @user.id)
      render json: expenses
    end
  end

  def create
    puts 'CURRENT', @user.id
    expense = Expense.create(create_params)
    if expense.save
      render json: expense, status: :created
      puts 'EXPENSE: ', expense
    elsif @user.nil?
      render json: { error: "You're not authorised to do this." }, status: :unauthorized
    end
  end

  def show
    render json: @expense
  end

  def update
    expense = Expense.find(params.require(:id))
    expense.update!(update_params)
    render json: expense
  end

  def destroy
    puts 'SESSION_ID: ', @user.session_id
    if @user.session_id.nil?
      render status :unauthorized
    end

    @expense.destroy
    render json: { message: 'The expense was deleted successfully.' }
  end

  private

  def set_expense
    @expense = Expense.find(params.require(:id))
  end

  def create_params
    params
      .require(:expense)
      .permit(:title, :amount_in_cents, :date)
      .tap do |expense_params|
      expense_params.require(:title)
      expense_params.require(:amount_in_cents)
      expense_params.require(:date)
      expense_params[:user_id] = current_user.id
    end
  end

  def update_params
    params.require(:expense).permit(:title, :amount_in_cents, :date)
  end

  def set_user
    @user = current_user
  end
end
