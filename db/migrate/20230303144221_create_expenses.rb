class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :title, null: false
      t.integer :amount_in_cents, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
