require 'rails_helper'

RSpec.describe Expense do
  context 'validations' do
    context 'when title missing' do
      it 'returns bad request' do
        expense = Expense.new(title: nil)

        expect(expense).not_to be_valid
      end
    end
  end
end
