class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true, name: 'unique_emails' }
      t.string :password_digest
      t.string :tax_id, index: true

      t.timestamps
    end
  end
end
