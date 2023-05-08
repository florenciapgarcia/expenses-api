# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense do
	context 'validations' do
		context 'when title attribute is empty' do
			it 'is not valid' do
				expense = build(:expense, title: nil)

				expect(expense).not_to be_valid
			end
		end

		context 'when amount_in_cents attribute is empty' do
			it 'is not valid' do
				expense = build(:expense, amount_in_cents: nil)

				expect(expense).not_to be_valid
			end
		end

		context 'when date attribute is empty' do
			it 'is not valid' do
				expense = build(:expense, date: nil)

				expect(expense).not_to be_valid
			end
		end

	context 'when amount_in_cents is not empty' do
		context 'when amount_in_cents is not an integer' do
			it 'is not valid' do
				expense = build(:expense, :invalid_amount)

				expect(expense).not_to be_valid
			end
		end

		context 'when amount_in_cents is smaller than 0' do
			it 'is not valid' do
				expense = build(:expense, amount_in_cents: -100)

				expect(expense).not_to be_valid
			end
		end
	end

	context 'when valid attributes passed' do
		it 'is valid' do
			expense = create(:expense)

			expect(expense).to be_valid
		end
	end
end

# TODO - test association
end
