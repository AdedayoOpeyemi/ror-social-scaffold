class Friendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user, index: true
      t.references :friend, index: true
      t.string :status, default: 'pending'

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :user_id
    add_foreign_key :friendships, :users, column: :friend_id
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
