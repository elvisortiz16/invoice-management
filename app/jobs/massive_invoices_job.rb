class MassiveInvoicesJob < ApplicationJob

    def perform(path)
       InvoiceService.massive_upload(path)
      end
end
  