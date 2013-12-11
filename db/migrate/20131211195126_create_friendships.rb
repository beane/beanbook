class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :inbound_friend_id, null: false
      t.integer :outbound_friend_id, null: false
      t.boolean :pending, default: true, null: false

      t.timestamps
    end

    add_index :friendships, [:inbound_friend_id, :pending]
    add_index :friendships, [:inbound_friend_id, :outbound_friend_id]
  end
end
