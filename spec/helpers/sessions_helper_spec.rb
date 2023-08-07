# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#log_in' do
    it 'sets session[:user_id]' do
      log_in(user)

      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#current_user' do
    context 'when the user is not logged in' do
      it 'doesn\'t do anything' do
        expect(current_user).to eq(nil)
      end
    end

    context 'when the user is logged in' do
      it 'sets @current_user value' do
          log_in(user)

          expect(current_user).to eq(user)
      end
    end
    end

  describe '#logged_in?' do
    context 'when user is logged out' do
      it 'returns false' do
        expect(logged_in?).to eq(false)
      end
    end

    context 'when user is logged in' do
      it 'returns true' do
        log_in(user)

        expect(logged_in?).to eq(true)
      end
    end
  end

  describe '#log_out' do
    context 'when no user is logged in' do
      it 'does not do anything' do
        log_out

        expect(current_user).to eq(nil)
        expect(session[:user_id]).to eq(nil)
      end
    end

    context 'when user is logged in' do
      it 'logs user out' do
      log_in(user)

      expect(current_user).to eq(user)

      log_out

      expect(current_user).to eq(nil)
      expect(session[:user_id]).to eq(nil)
      end
    end
  end
end
