class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
  end

  def create
    @expense = Expense.new(expense_params)
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :amount, :date)
  end

  def show
    @expense = Expense.find(params[:id])
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
end
