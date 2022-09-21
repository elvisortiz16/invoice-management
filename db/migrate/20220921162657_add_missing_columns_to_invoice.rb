class AddMissingColumnsToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :emitter_name, :string
    add_column :invoices, :emitter_rfc, :string
    add_column :invoices, :receiver_name, :string
    add_column :invoices, :receiver_rfc, :string
  end
end
