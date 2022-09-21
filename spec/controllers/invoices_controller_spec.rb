# frozen_string_literal: true

RSpec.describe 'InvoicesController', type: :request do
  describe 'invoices controller' do
    context 'without user logged in' do
      it 'get return 401 unauthorized' do
        get '/invoices'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'post return 401 unauthorized' do
        post '/invoices'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'patch return 401 unauthorized' do
        patch '/invoices/1'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'delete return 401 unauthorized' do
        delete '/invoices/1'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'total return 401 unauthorized' do
        get '/invoices/total'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'qr return 401 unauthorized' do
        get '/invoices/1/qr'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'massive return 401 unauthorized' do
        post '/invoices/massive'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with user logged in' do
      let(:invoice) { create(:invoice) }
      let(:file) { fixture_file_upload( Rails.root.join('spec/fixtures/upload_example.zip')) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
      end

      it 'get return 200' do
        get '/invoices'
        expect(response).to have_http_status(:ok)
      end

      it 'post return 200' do
        post '/invoices'
        expect(response).to have_http_status(:ok)
      end

      it 'patch return 200' do
        patch "/invoices/#{invoice.id}"
        expect(response).to have_http_status(:ok)
      end

      it 'delete return 200' do
        delete "/invoices/#{invoice.id}"
        expect(response).to have_http_status(:ok)
      end

      it 'total return 200' do
        get '/invoices/total'
        expect(response).to have_http_status(:ok)
      end

      it 'qr return 200 and a image' do
        get "/invoices/#{invoice.id}/qr"
        expect(response).to have_http_status(:ok)
        expect(response.headers['Content-Type']).to eq('image/png')
      end

      it 'massive return 200 and true' do
        post '/invoices/massive', params: { file: }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_truthy
      end

      context 'when invoice doesnt exist' do
        it 'patch return 404' do
          patch '/invoices/0'
          expect(response).to have_http_status(:not_found)
        end

        it 'delete return 404' do
          delete '/invoices/0'
          expect(response).to have_http_status(:not_found)
        end

        it 'qr return 404' do
          get '/invoices/0/qr'
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
