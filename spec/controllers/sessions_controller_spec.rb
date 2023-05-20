require 'rails_helper'
RSpec.describe SessionsController do
  let(:user) { create(:user) }
  before { session[:user_id] = user.id }

  describe 'POST /login' do

    context 'when params are missing' do
      let(:email) { 'test@test.com' }
      let(:password) { 'password' }

      context 'when no params are passed' do
        before { post :create, params: {} }

        it 'returns bad_request' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when email param is missing' do
        before { post :create, params:{ session: { password: }} }

        it 'returns bad_request' do
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include('email')
        end
      end

      context 'when password param is missing' do
        before { post :create, params:{ session: { email: }} }

        it 'returns bad_request' do
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include('password')
        end
      end
    end

    context 'when invalid params are passed' do
      let(:params) { { session: { email: user.email, password: 'wrong_password'} } }
      before { post(:create, params:) }

      it 'returns anauthorized' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ message: 'Your password is invalid. Please retry.' }.to_json)
      end
    end

    context 'when valid params are passed' do
      let(:params) { {session: { email: user.email, password: user.password} }}

      before { post(:create, params:) }
      it 'returns success' do
        post(:create, params:)

        expect(response).to have_http_status(:success)
      end

      it 'creates a new session and stores user_id' do
        expect(session[:user_id]).not_to be_nil
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe 'DELETE /logout' do
    context 'when user is not logged in' do
      before { session[:user_id] = nil }

      it 'returns bad_request' do
        delete(:destroy)

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is logged in' do
      before { delete(:destroy) }

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns sucess message' do
        expect(response.body).to eq( {message: 'You have logged out successfully.' }.to_json)
      end

      it 'removes user_id from the session' do
        expect(session[:user_id]).to be_nil
      end
    end
  end
  end
