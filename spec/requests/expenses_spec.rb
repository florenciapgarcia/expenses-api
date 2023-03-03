require "rails_helper"

RSpec.describe "Expenses", type: :request do
  describe "GET /expenses" do
    it "works!" do
      expense = create(:expense)
      get expenses_index_path(expense_id: expense.id)
      expect(response).to have_http_status(200)
    end
  end
end
