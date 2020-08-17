class Friendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :requester, index: true
      t.references :requestee, index: true
      t.string :status, default: 'pending'

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :requester_id
    add_foreign_key :friendships, :users, column: :requestee_id
    add_index :friendships, [:requester_id, :requestee_id], unique: true
  end
end
