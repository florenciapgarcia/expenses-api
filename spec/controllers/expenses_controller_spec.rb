require 'rails_helper'

RSpec.describe ExpensesController do
  describe 'GET /users/:user_id/expenses' do
    let(:user) { create(:user) }
    let(:params) { { user_id: user.id } }

    before do
      session[:user_id] = user.id
    end

    context 'when no expenses exist' do
      before { (get :index, params:) }
      it 'returns success' do

        expect(response).to have_http_status(:success)
      end

      it 'returns no expenses' do
        response_body = JSON.parse(response.body)
        expect(response_body).to eq([])
      end
    end

    context 'when expenses exist' do
      let!(:expenses) { create_list(:expense, 10, user: user) }
      before { get :index, params: { user_id: user.id } }

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns expenses' do
        expect(response.body).to eq(expenses.to_json)
      end
    end
  end

  describe 'POST /users/:user_id/expenses' do
    let(:user) { create(:user) }

    context 'when user is not logged in' do
      let(:params) {create(:expense)}
      it 'returns unauthorised' do
        session[:user_id] = nil
        post(:create, params: {expense: {title: params.title, amount_in_cents: params.amount_in_cents, date: params.date}, user_id: user.id})

        expect(response).to have_http_status(:unauthorized)
    end
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end
      context 'when expense params are missing' do
        it 'returns bad request' do
          post :create, params: { user_id: user.id }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when expense params are passed' do
        context 'when title param is missing' do
          it 'returns bad request' do
            post :create,
                 params: {
                   expense: {
                     amount_in_cents: 100,
                     date: Date.current,
                   },
                   user_id: user.id
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
                     date: Date.current,
                   },
                   user_id: user.id
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
                     amount_in_cents: 1000,
                   },
                   user_id: user.id
                 }

            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'when title, amount_in_cents, date params are passed' do
          let(:title) { 'vet shop' }
          let(:amount_in_cents) { 1000 }
          let(:date) { Date.current }
          let!(:user) { create(:user) }
          let!(:params) { { expense: { title:, amount_in_cents:, date: }, user_id: user.id } }

          before do
            session[:user_id] = user.id
          end

          it 'returns created' do
            post(:create, params:)

            expect(response).to have_http_status(:created)
          end

          it 'creates a new expense record' do
            expect { post :create, params: }.to change(Expense, :count)

            created_expense = Expense.last

            expect(created_expense.title).to eq(title)
            expect(created_expense.amount_in_cents).to eq(amount_in_cents)
            expect(created_expense.date).to eq(date)
          end

          it 'returns the newly created expense' do
            post(:create, params:)

            expect(response.body).to eq(Expense.last.to_json)
          end
        end
      end
    end
  end
 end

  describe 'GET users/:user_id/expenses/:id' do
    let(:expense) { create(:expense) }
    let(:user) { create(:user) }
    let(:params) { { id: expense.id, user_id: user.id } }

    before do
      session[:user_id] = user.id
    end

    context 'when id param is missing' do
      it 'returns bad request' do
        get :show, params: { user_id: user.id, id: '' }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when id param is passed' do
      context 'when id param is invalid' do
        it 'returns not found' do
          get :show, params: { id: 'invalid_id', user_id: user.id }

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when id param is valid' do
        before { get(:show, params:) }

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'responds with correct expense' do
          expect(response.body).to eq(expense.to_json)
        end
      end
    end
  end

  describe 'PATCH /users/:user_id/expenses/:id' do
    let(:user) { create(:user) }
    let(:expense) { create(:expense) }
    before do
      session[:user_id] = user.id
    end

    context 'when id param is missing' do
      it 'returns bad request' do
        patch :update, params: { user_id: user.id, id: '' }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when id param is invalid' do
      it 'returns the same expense with no updates' do
        patch :update, params: { user_id: user.id, id: 'invalid_expense' }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id param is valid' do
      context 'when new title param is passed' do
        let(:new_title) { 'New title' }

        before do
          patch :update,
                params: {
                  id: expense.id,
                  user_id: user.id,
                  expense: {
                    title: new_title,
                  },
                }
        end

        it 'updates only the title' do
          updated_expense = Expense.find(expense.id)

          expect(updated_expense.title).to eq(new_title)
        end

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns updated expense' do
          updated_expense = Expense.find(expense.id)

          expect(response.body) == (updated_expense.to_json)
        end
      end

      context 'when amount_in_cents param is passed' do
        let(:new_amount_in_cents) { 11_500 }

        before do
          patch :update,
                params: {
                  id: expense.id,
                  user_id: user.id,
                  expense: {
                    amount_in_cents: new_amount_in_cents,
                  },
                }
        end

        it 'updates only the amount_in_cents' do
          updated_expense = Expense.find(expense.id)

          expect(updated_expense.amount_in_cents).to eq(new_amount_in_cents)
        end

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns updated expense' do
          updated_expense = Expense.find(expense.id)

          expect(response.body) == (updated_expense.to_json)
        end
      end

      context 'when date param is passed' do
        let(:new_date) { Date.new(2023, 3, 12) }
        before do
          patch :update,
                params: {
                  id: expense.id,
                  user_id: user.id,
                  expense: {
                    date: new_date,
                  },
                }
        end

        it 'updates only the date' do
          updated_expense = Expense.find(expense.id)

          expect(updated_expense.date).to eq(new_date)
        end

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns updated expense' do
          updated_expense = Expense.find(expense.id)

          expect(response.body) == (updated_expense.to_json)
        end
      end
    end
  end

  describe 'DELETE /users/:user_id/expenses/:id' do
    let(:user) { create(:user) }
    let(:expense) { create(:expense) }

    context 'when user is logged out' do
      it 'returns unauthorised' do
        delete :destroy, params: { id: expense.id,
                                   user_id: user.id, }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      after do
        session[:user_id] = nil
      end

      context 'when id param is missing' do
        it 'returns bad request' do
          delete :destroy, params: { id: '',
                                     user_id: user.id, }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when id param is passed' do
        context 'when id is invalid' do
          it 'returns not found' do
            delete :destroy, params: { id: 'invalid_id',
                                       user_id: user.id, }

            expect(response).to have_http_status(:not_found)
          end
        end

        context 'when id is valid' do
          it 'returns success' do
            delete :destroy, params: { id: expense.id, user_id: user.id }

            expect(response).to have_http_status(:success)
            expect(response.body).to eq({ message: 'The expense was deleted successfully.' }.to_json)
          end
        end
      end
    end
  end
end
