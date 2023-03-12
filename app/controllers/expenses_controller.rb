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
    if params[:id].blank?
      render json: { error: 'Bad Request' }, status: :bad_request
    else
      expense = Expense.find(params[:id])
      render json: expense
    end
  end


# TODO - 
  def update
    expense = Expense.find(params[:id])
    expense.update!(expense_params)
    # TODO - tal vez aca tendria que hacer un if, si no me pasa params que me devuelva el mismo objeto?? o un 'nada para actualizar', pero si se actuliza bien que me mande un mensaje que diga 'successfully updated
    render json: expense
  end

  def destroy
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
