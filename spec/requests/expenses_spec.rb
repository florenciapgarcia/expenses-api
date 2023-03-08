require "rails_helper"

RSpec.describe "Expenses", type: :request do
  describe "GET /expenses" do
    before do
      create_list(:expense, 8)
      get "/expenses"
    end
    it "returns a succesful response" do
      expect(response).to have_http_status(:success)
    end
    it "retrieves all expenses" do
      p create_list(:expense, 8)
      expect(:expenses.size).to eq(8)
    end
  end
end
