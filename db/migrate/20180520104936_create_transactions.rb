class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :service
      t.integer :value_cents
      t.text :details
      t.timestamp :purchased_at
      t.string :message_uid, index: true
      t.references :account, foreign_key: true
    end
  end
end
