# frozen_string_literal: true

# spec/helpers/sessions_helper_spec.rb

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
    context 'when the user does not exist' do
      it 'doesn\'t do anything' do
        expect(current_user).to eq(nil)
      end
    end

    context 'when the user exists' do
      before { log_in(user) }
      context 'when @current_user is already set' do
        before { assign(:current_user, user) }

        it 'does not modify @current_user' do
          puts user.first_name
          log_in(create(:user))

          expect(current_user).to eq(user)
        end
      end

      context 'when @current_user is not nil' do
        it 'returns the @current_user' do
          expect(current_user).to eq(user)
        end
      end
    end
  end

  describe '#log_out' do
  end
end
