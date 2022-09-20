# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password_digest { '$2a$12$oaKg06NgGvsx4Ukp3/EUgeILOBN0rQtA2l8HFdzN1iRRBDlzvmG9O' }
    tax_id { FFaker::IdentificationMX.rfc_persona_moral }
  end
end
