# frozen_string_literal: true

class User < ApplicationRecord
  has_many :emitter_invoices, class_name: 'Invoice', foreign_key: 'emitter_id', dependent: :nullify,
                              inverse_of: :emitter
  has_many :receiver_invoices, class_name: 'Invoice', foreign_key: 'receiver_id', dependent: :nullify,
                               inverse_of: :receiver
end
