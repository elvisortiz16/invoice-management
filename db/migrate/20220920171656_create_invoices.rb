class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_uuid,index: true
      t.string :status,index: true
      t.string :cfdi_digital_stamp
      t.string :currency
      t.decimal :amount,index: true
      t.datetime :emitted_at,index: true
      t.datetime :expires_at
      t.datetime :signed_at

      t.timestamps

      t.references :emitter, index: true, foreign_key: { to_table: :users }
      t.references :receiver, index: true, foreign_key: { to_table: :users }
    end
  end
end
