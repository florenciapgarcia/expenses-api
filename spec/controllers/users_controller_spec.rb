# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  describe 'GET /users' do
    # before { User.delete_all }

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
      let!(:users) { create_list(:user, 2) }

      it 'returns success' do
        get :index

        expect(response).to have_http_status(:success)
      end

      it 'returns users' do
        get :index

        expect(response.body).to include(users.to_json)
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end
  end

  describe 'POST /users' do
    # TODO: - replace with Faker
    let(:first_name) { 'test' }
    let(:last_name) { 'tester' }
    let(:email) { 'test@test.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }

    context 'when user params are missing' do
      it 'returns bad request' do
        post :create, params: {}

        expect(response).to have_http_status(:bad_request)
      end
    end
    # TODO: - loop (params.keys - remove from params hash as we're looping)
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
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when last_name param is missing' do
        it 'returns bad request' do
          post :create,
               params: {
                 first_name:,
                 last_name: '',
                 email:,
                 password:,
                 password_confirmation:
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
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when password param is missing' do
        it 'returns bad_request' do
          post :create,
               params: {
                 user: {
                   first_name:,
                   last_name:,
                   email:,
                   password: '',
                   password_confirmation:
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when password_confirmation param is missing' do
        it 'returns bad_request' do
          post :create,
               params: {
                 user: {
                   first_name:,
                   last_name:,
                   email:,
                   password:,
                   password_confirmation: ''
                 }
               }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when valid params are passed' do
        let(:params) { { user: { first_name:, last_name:, email:, password:, password_confirmation: } } }

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
        get :show, params: { id: '' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      context 'when id param doesn\'t match logged in user_id' do
        it 'returns unauthorized' do
          get :show, params: { id: 'wrong_id' }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when id param matches logged in user_id' do
        before do
          get :show, params: { id: 1 }
        end

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns the correct user' do
          expect(response.body).to include(user.to_json)
        end
      end
    end
  end

  describe 'PATCH /users/:id' do
    # TODO: - use Faker
    let(:new_first_name) { 'Test' }
    let(:new_last_name) { 'Tester' }
    let(:new_email) { 'test@test.com' }
    let(:new_password) { 'password' }
    let(:new_password_confirmation) { 'password' }
    let(:new_params) do
      { id: user.id,
        user: { first_name: new_first_name, last_name: new_last_name, email: new_email, password: new_password,
                password_confirmation: new_password_confirmation } }
    end
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'when user is not logged in' do
      it 'returns unauthorized' do
        patch :update, params: { id: user.id, user: another_user }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      # TODO: - add a before each and include session[:user_id] = @user.id here isntead
      before do
        # TODO: - refactor using let block
        session[:user_id] = user.id
      end

      context 'when no user params to update are passed' do
        it 'returns bad request' do
          patch :update, params: { id: user.id, user: {} }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when invalid user params to update are passed' do
        # TODO: - should return not_found (for every user_id that doesn't match the logged in user's id)
        context 'when invalid user_id is passed' do
          it 'returns bad_request' do
            patch :update, params: { id: 'wrong_id', user: new_params }

            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'when password doesn\'t match password_confirmation' do
          before do
            patch :update, params: { id: @user.id, user: { password: 'password', password_confirmation: 'pazzword' } }
          end
          it 'returns bad request' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns message passwords don\t match' do
            expect(response.body).to include('Password confirmation doesn\'t match Password')
          end
        end
      end

      context 'when user params to be updated are passed' do
        before do
          patch :update, params: new_params
        end

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'updates the user' do
          expect(@user.reload.first_name).to eq(new_first_name)
        end

        it 'returns the updated user' do
          expect(response.body) == (@user.reload.to_json)
        end

        it 'updates only the specified user' do
          expect(@user.reload.first_name).to eq(new_first_name)
          expect(another_user.reload.first_name).to_not eq(new_first_name)
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    # TODO: - move to individual contexts
    before do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    context 'when user is not logged in' do
      it 'returns unauthorized' do
        # remove below
        session[:user_id] = nil

        delete :destroy, params: { id: '' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      context 'when id is invalid' do
        it 'returns unauthorized' do
          delete :destroy, params: { id: 'invalid_id' }

          # TODO: - should return 404
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when id is valid' do
        before { delete :destroy, params: { id: @user.id } }

        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns message of successfully deleted user' do
          expect(response.body).to include('The user was deleted successfully.')
        end
      end
    end
  end
end
