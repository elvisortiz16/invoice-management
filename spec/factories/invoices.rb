# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    invoice_uuid { SecureRandom.uuid }
    status { 'active' }
    cfdi_digital_stamp { FFaker::DizzleIpsum.characters }
    currency { FFaker::Currency.code }
    amount { 99_999 }
    emiter { nil }
    receiver { nil }
    emitted_at { FFaker::Time.date }
    expires_at { FFaker::Time.date }
    signed_at { FFaker::Time.date }
  end
end
