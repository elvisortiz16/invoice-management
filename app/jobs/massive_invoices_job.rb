# frozen_string_literal: true

class MassiveInvoicesJob < ApplicationJob
  def perform(path)
    InvoiceService.massive_upload(path)
  end
end
