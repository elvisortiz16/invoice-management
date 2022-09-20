# frozen_string_literal: true

RSpec.describe 'SessionsController', type: :request do
  describe 'post /sessions create user token' do
    shared_examples 'unauthorized' do |params|
      it 'returns a 401 status' do
        params[:email] = user.email if params[:email].nil?
        post '/sessions', params: params
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).not_to include('token')
      end
    end
    let(:user) { create(:user) }

    context 'when user exist' do
      it 'returns a 200 status and token' do
        post '/sessions', params: { email: user.email, password: '1234567890' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('token')
      end
    end

    context 'when password is invalid' do
      include_examples 'unauthorized',  { password: '12345678901' }
    end

    context 'when user not found' do
      include_examples 'unauthorized',  { email: FFaker::Internet.email, password: '1234567890' }
    end
  end
end
