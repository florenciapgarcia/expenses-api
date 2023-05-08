# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show destroy]
  before_action :set_user, only: %i[create show destroy update]

  def index
    expenses = Expense.all
    render json: expenses
  end

  def create
    expense = Expense.create(create_params)
    if expense.save
      render json: expense, status: :created
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
      .permit(:title, :amount_in_cents, :date, :user_id)
      .tap do |expense_params|
        expense_params.require(:title)
        expense_params.require(:amount_in_cents)
        expense_params.require(:date)
        expense_params[:user_id] = @user
      end
  end

  def update_params
    params.require(:expense).permit(:title, :amount_in_cents, :date, :user_id)
  end

  def set_user
    @user = current_user.id
  end
end
