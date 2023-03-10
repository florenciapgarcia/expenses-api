class ExpensesController < ApplicationController
  def index
    expenses = Expense.all
    render json: expenses
  end

  def create
    expense = Expense.create(expense_params)
    render json: expense
  end

  def show
    expense = Expense.find(params[:id])
    p expense #require id test -(missing, valid, invalid)
    render json: expense
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.update!(expense_params)
  end

  def destroy
    # show.destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
  end

  private

  def expense_params
    params
      .require(:expense)
      .permit(:title, :amount_in_cents, :date)
      .tap do |expense_params|
        expense_params.require(:title)
        expense_params.require(:amount_in_cents)
        expense_params.require(:date)
      end
  end
end
