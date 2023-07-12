# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
	context 'validations' do
		context 'when first_name attribute is empty' do
			it 'is not valid' do
				user = build(:user, first_name: nil)

				expect(user).not_to be_valid
			end
		end

		context 'when last_name attribute is empty' do
			it 'is not valid' do
				user = build(:user, last_name: nil)

				expect(user).not_to be_valid
			end
		end

		context 'when email attribute is empty' do
			it 'is not valid' do
				user = build(:user, email: nil)

				expect(user).not_to be_valid
			end
		end
		context 'when password attribute is empty' do
			it 'is not valid' do
				user = build(:user, password: nil, password_confirmation: nil)

				expect(user).not_to be_valid
			end
		end

	context 'when first_name attribute is passed' do
		context 'when first_name is longer than 50 characters' do
			it 'is not valid' do
				user = build(:user, first_name: 'f' * 51)

				expect(user).to_not be_valid
			end
		end
	end

	context 'when last_name attribute is passed' do
		context 'when last_name is longer than 50 characters' do
			it 'is not valid' do
				user = build(:user, last_name: 'p' * 51)

				expect(user).to_not be_valid
			end
		end
	end

	context 'when valid attributes passed' do
		it 'is valid' do
			user = create(:user)

			expect(user).to be_valid
		end
	end
end


	context 'associations' do
		it { should respond_to(:expenses) }
  end
end
