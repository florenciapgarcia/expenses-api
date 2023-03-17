class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show destroy]

  def index
    expenses = Expense.all
    render json: expenses
  end

  def create
    expense = Expense.create(create_params)
    render json: expense, status: :created
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
      end
  end

  def update_params
    params
      .require(:id, :expense)
  end
end
