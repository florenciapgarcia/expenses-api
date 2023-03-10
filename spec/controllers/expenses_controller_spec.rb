require 'rails_helper'

RSpec.describe ExpensesController do
  describe 'GET /expenses' do
    context 'when no expenses exist' do
      it 'returns success' do
        get :index

        expect(response).to have_http_status(:success)
      end

      it 'returns no expenses' do
        get :index

        response_body = JSON.parse(response.body)
        expect(response_body).to eq([])
      end
    end

    context 'when expenses exist' do
      let!(:expenses) { create_list(:expense, 10) }

      it 'returns success' do
        get :index

        expect(response).to have_http_status(:success)
      end

      it 'returns expenses' do
        get :index

        expect(response.body).to eq(expenses.to_json)
      end
    end
  end

  describe 'POST /expenses' do
    context 'when expense param is missing' do
      it 'returns bad request' do
        post :create, params: {}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when expense param is passed' do
      context 'when title param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 expense: {
                   amount_in_cents: 100,
                   date: Date.current
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when amount_in_cents param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 expense: {
                   title: 'vet shop',
                   date: Date.current
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when date param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 expense: {
                   title: 'vet shop',
                   amount_in_cents: 1000
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end

        context 'when title, amount_in_cents, date params is passed' do
          let(:title) { 'vet shop' }
          let(:amount_in_cents) { 1000 }
          let(:date) { Date.current }
          let(:params) do
            {
              expense: { title:, amount_in_cents:, date: }
            }
          end

          it 'returns success' do
            post(:create, params:)

            expect(response).to have_http_status(:success)
          end

          it 'creates a new expense record' do
            expect { post :create, params: }.to change(Expense, :count)

            created_expense = Expense.last
            expect(created_expense.title).to eq(title)
            expect(created_expense.amount_in_cents).to eq(amount_in_cents)
            expect(created_expense.date).to eq(date)
          end
        end
      end
    end
  end

  describe 'GET /expenses/:id' do
  context "when id param is missing" do
    it "returns bad request" do
      get :show, params: {}

      expect(response).to have_http_status(:bad_request)
    end
  end

  # context "when id param is passed" do
 
  # context "when id param is invalid" do
  #   it "" do
  #   end
  # end
  # context "when id param is valid" do
  #   it "" do
  #   end
  # end
  # end
  end
end
