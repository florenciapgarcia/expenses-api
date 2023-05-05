class AddUserToExpenses < ActiveRecord::Migration[7.0]
  def change
    # this migration is needed to add user_id as foreign key to expenses table
    add_reference :expenses, :user, null: false, foreign_key: true
  end
end
