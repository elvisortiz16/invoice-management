# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sessions, only: :create
  resources :invoices, only: %i[index create update destroy]
  get 'invoices/total', action: :total, controller: :invoices
  get 'invoices/:id/qr', action: :generate_qr, controller: :invoices
  post 'invoices/massive', action: :massive_upload, controller: :invoices
end
