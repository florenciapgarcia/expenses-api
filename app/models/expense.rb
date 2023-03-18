class Expense < ApplicationRecord
  validates :title,
            presence: {
              message: 'Please enter a title for your expense',
            }
  validates :amount_in_cents,
            presence: {
              message: 'Please enter an amount in cents',
            },
            numericality: {
              only_integer: true,
              greater_than: 0,
            }
  validates :date, presence: { message: 'Please set a date' }
end
