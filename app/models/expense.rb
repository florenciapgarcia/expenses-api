# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :amount_in_cents,
            numericality: {
              only_integer: true,
              greater_than: 0
            },
            presence: true
  validates :date, presence: true
  validates :user_id, presence: true
end
