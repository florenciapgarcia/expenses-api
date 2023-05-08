require 'rails_helper'

RSpec.describe SessionsController do
describe 'POST /login' do
  context 'when no params are passed' do
    let(:user) { create(:user) }
    it 'returns unathorized' do
      post :create, params: {}

      expect(response).to have_http_status(:unauthorized)
    end

    it 'displays message' do
      post :create, params: {}

      expect(response.body).to eq({"message":"Sign in with your credentials."}.to_json)
    end
  end

  context 'when params are passed' do

  end
end

# describe 'DELETE /logout' do

# end
end
