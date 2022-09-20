# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :emitter, class_name: 'User', optional: true, inverse_of: :emitter_invoices
  belongs_to :receiver, class_name: 'User', optional: true, inverse_of: :receiver_invoices
end
