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
          let(:params) { { expense: { title:, amount_in_cents:, date: } } }

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
    let(:expense) { create(:expense) } # create a sample expense record

    context 'with a valid id param' do
      it 'returns http success' do
        get :show, params: { id: expense.id }

        expect(response).to have_http_status(:success)
      end
    end

    context 'with an invalid id param' do
      it 'returns http not found' do
        get :show, params: { id: 'invalid_id' }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with a missing id param' do
      it 'returns http bad request' do
        get :show, params: { id: '' }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH /expenses/:id' do
    context 'when valid params are passed' do
      let!(:expense) do
        create(
          :expense,
          title: 'Skincare',
          amount_in_cents: 10_000,
          date: Date.current
        )
      context 'when title is passed' do
        let(:new_title) { 'New title' }
        it 'updates only the title' do
          patch :update,
                params: {
                  id: expense.id,
                  expense: {
                    title: new_title,
                    amount_in_cents: expense.amount_in_cents,
                    date: expense.date
                  }
                }

          updated_expense = Expense.find(expense.id)
          expect(response).to have_http_status(:success)
          expect(updated_expense.title).to eq(new_title)
        end
      end
    end
  end
  end
end
