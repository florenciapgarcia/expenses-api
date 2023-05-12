require 'rails_helper'

RSpec.describe UsersController do
  describe 'GET /users' do
    before { User.delete_all }

    context 'when no users exist' do
      it 'returns success' do
        get :index

        expect(response).to have_http_status(:success)
      end

      it 'returns no users' do
        get :index

        response_body = JSON.parse(response.body)
        expect(response_body).to eq([])
      end
    end

    context 'when users exist' do
      let!(:users) { create_list(:user, 10) }

      it 'returns success' do
        get :index

        expect(response).to have_http_status(:success)
      end

      it 'returns users' do
        get :index

        expect(response.body).to eq(users.to_json)
      end
    end
  end

  describe 'POST /users' do
    let(:first_name) {'test'}
    let(:last_name) {'tester'}
    let(:email) {'test@test.com'}
    let(:password) {'password'}
    let(:password_confirmation) {'password'}
    context 'when user params are missing' do
      it 'returns bad request' do
        post :create, params: {}

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user params are passed' do
      context 'when first_name param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 user: {
                  first_name: '',
                  last_name:,
                  email:,
                  password:,
                  password_confirmation:
                 },
               }

          expect(response).to have_http_status(:bad_request)
        end
      end


      context 'when last_name param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 user: {
                  first_name:,
                  last_name: '',
                  email:,
                  password:,
                  password_confirmation:
                 },
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when email param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 user: {
                  first_name:,
                  last_name:,
                  email: '',
                  password:,
                  password_confirmation:
                 },
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when password param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 user: {
                  first_name:,
                  last_name:,
                  email:,
                  password: '',
                  password_confirmation:
                 },
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when password_confirmation param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 user: {
                  first_name:,
                  last_name:,
                  email:,
                  password:,
                  password_confirmation: ''
                 },
               }

          expect(response).to have_http_status(:bad_request)
        end
      end


      context 'when valid params are passed' do
        let(:params) {{user: {first_name:, last_name:, email:, password:, password_confirmation:}}}
        it 'returns created' do

          post(:create, params:)

          expect(response).to have_http_status(:created)
        end
      it 'creates a new user record' do
        expect { post :create, params: }.to change(User, :count)

        created_user = User.last

        expect(created_user.first_name).to eq(first_name.capitalize)
        expect(created_user.last_name).to eq(last_name.capitalize)
        expect(created_user.email).to eq(email)
        expect(BCrypt::Password.new(created_user.password_digest)).to eq(password)
      end


        it 'returns message: user was created successfully' do
          post(:create, params:)

          expect(response.body).to eq({ message: 'The user was created successfully.' }.to_json)
        end
      end

  end
end

  describe 'GET /users/:id' do
    let(:user) { create(:user) }

    context 'when user is not logged in' do
      it 'returns unauthorized' do
        get :show, params: { id: ''}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      before do
          session[:user_id] = user.id
          get :show, params: { id: 1 }
      end

      context 'when id param doesn\'t match logged in user_id' do
        it 'returns unauthorized' do
          get :show, params: { id: ''}

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when id param matches logged in user_id'
      it 'returns success' do
        # puts response.body
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct user' do
        expect(response.body).to include(user.full_name)
        expect(response.body).to include(user.email)
        expect(response.body).to include(user.created_at.strftime('%Y-%m-%dT%H:%M:%S.%L').to_s)
      end
    end
  end
  # describe 'PATCH /expenses/:id' do
  #   before { @expense = create(:expense) }

  #   context 'when id param is missing' do
  #     it 'returns bad request' do
  #       patch :update, params: { id: '', expense: @expense }

  #       expect(response).to have_http_status(:bad_request)
  #     end
  #   end

  #   context 'when expense param is missing' do
  #     let(:expense) { create(:expense) }
  #     it 'returns the same expense with no updates' do
  #       patch :update, params: { id: @expense.id }

  #       expect(response).to have_http_status(:bad_request)
  #     end
  # end

  #   context 'when id param is passed' do
  #     context 'when id param is invalid' do
  #       it 'returns not found' do
  #         patch :update, params: { id: 'invalid_id', expense: @expense }

  #         expect(response).to have_http_status(:not_found)
  #       end
  #     end

  #     context 'when id param is valid' do
  #       context 'when new title param is passed' do
  #         let(:new_title) { 'New title' }
  #         before do
  #           patch :update,
  #                 params: {
  #                   id: @expense.id,
  #                   expense: {
  #                     title: new_title,
  #                   },
  #                 }
  #         end

  #         it 'updates only the title' do
  #           updated_expense = Expense.find(@expense.id)
  #           expect(updated_expense.title).to eq(new_title)
  #         end

  #         it 'returns success' do
  #           expect(response).to have_http_status(:success)
  #         end

  #         it 'returns updated expense' do
  #           updated_expense = Expense.find(@expense.id)
  #           expect(response.body) == (updated_expense.to_json)
  #         end
  #       end
  #     end

  #     context 'when amount_in_cents param is passed' do
  #       let(:new_amount_in_cents) { 11_500 }
  #       before do
  #         patch :update,
  #               params: {
  #                 id: @expense.id,
  #                 expense: {
  #                   amount_in_cents: new_amount_in_cents,
  #                 },
  #               }
  #       end

  #       it 'updates only the amount_in_cents' do
  #         updated_expense = Expense.find(@expense.id)
  #         expect(updated_expense.amount_in_cents).to eq(new_amount_in_cents)
  #       end

  #       it 'returns success' do
  #         expect(response).to have_http_status(:success)
  #       end

  #       it 'returns updated expense' do
  #         updated_expense = Expense.find(@expense.id)
  #         expect(response.body) == (updated_expense.to_json)
  #       end
  #     end

  #     context 'when date param is passed' do
  #       let(:new_date) { Date.new(2023, 3, 12) }
  #       before do
  #         patch :update,
  #               params: {
  #                 id: @expense.id,
  #                 expense: {
  #                   date: new_date,
  #                 },
  #               }
  #       end

  #       it 'updates only the date' do
  #         updated_expense = Expense.find(@expense.id)
  #         expect(updated_expense.date).to eq(new_date)
  #       end

  #       it 'returns success' do
  #         expect(response).to have_http_status(:success)
  #       end

  #       it 'returns updated expense' do
  #         updated_expense = Expense.find(@expense.id)
  #         expect(response.body) == (updated_expense.to_json)
  #       end
  #     end
  #   end
  # end

  # describe 'DELETE /expenses/:id' do
  #   before { @expense = create(:expense) }

  #   context 'when id param is missing' do
  #     it 'returns bad request' do
  #       delete :destroy, params: { id: '' }

  #       expect(response).to have_http_status(:bad_request)
  #     end
  #   end

  #   context 'when id param is passed' do
  #     context 'when id is invalid' do
  #       it 'returns not found' do
  #         delete :destroy, params: { id: 'invalid_id' }

  #         expect(response).to have_http_status(:not_found)
  #       end
  #     end

  #     context 'when id is valid' do
  #       it 'returns success' do
  #         delete :destroy, params: { id: @expense.id }

  #         expect(response).to have_http_status(:no_content)
  #       end
  #     end
  #   end
  # end
end
