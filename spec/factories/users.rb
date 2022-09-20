# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password_digest { 'MyString' }
    tax_id { FFaker::IdentificationMX.rfc_persona_moral }
  end
end
