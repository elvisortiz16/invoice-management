# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    invoice_uuid { SecureRandom.uuid }
    status { 'active' }
    cfdi_digital_stamp { FFaker::DizzleIpsum.characters }
    currency { FFaker::Currency.code }
    amount { 99_999 }
    emitter { nil }
    emitter_name { FFaker::NameMX.full_name }
    emitter_rfc { FFaker::IdentificationMX.rfc_persona_moral }
    receiver { nil }
    receiver_name { FFaker::NameMX.full_name }
    receiver_rfc { FFaker::IdentificationMX.rfc_persona_moral }
    emitted_at { FFaker::Time.date }
    expires_at { FFaker::Time.date }
    signed_at { FFaker::Time.date }
  end
end
