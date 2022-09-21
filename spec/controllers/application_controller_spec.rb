# frozen_string_literal: true

RSpec.describe 'ApplicationController', type: :request do
  describe 'Application controller' do
    context 'with locale' do
      it 'sets locale' do
        get '/invoices', headers: { locale: :en }
        expect(I18n.locale).to eq(:en)
      end

      it 'sets default locale' do
        get '/invoices', headers: { locale: :es }
        expect(I18n.locale).to eq(:es)
      end
    end

    context 'without user logged in' do
      it 'get return 401 unauthorized' do
        get '/invoices'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with user logged in' do
      before do
        allow(Current).to receive(:user).and_return(user)
      end

      let(:user) { create(:user) }
      let(:token) { JWT.encode(user.to_json, 'secret', 'HS256') }

      it 'get return 200' do
        get '/invoices', headers: { token: }
        expect(response).to have_http_status(:ok)
        expect(Current.user).to eq(user)
      end
    end
  end
end
