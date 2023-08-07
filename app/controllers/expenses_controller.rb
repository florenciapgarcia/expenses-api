# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show destroy]
  before_action :set_user, only: %i[index create show destroy update]
  before_action :require_login, only: %i[index create show destroy update]
  skip_before_action :verify_authenticity_token, only: %i[destroy create update]

  include SessionsHelper

  def index
    return unless @user.id == params[:user_id].to_i

    expenses = Expense.where(user_id: @user.id)
    render json: expenses
  end

  def create
    expense = Expense.create(create_params)
    if expense.save
      render json: expense, status: :created
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
      expense_params[:user_id] = @user.id
    end
  end

  def update_params
    params.require(:expense).permit(:title, :amount_in_cents, :date)
  end

  def set_user
    @user = current_user
  end

  def require_login
    return if logged_in? && @user.id == params[:user_id].to_i

    head :unauthorized
  end
end
