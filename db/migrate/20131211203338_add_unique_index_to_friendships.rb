class AddUniqueIndexToFriendships < ActiveRecord::Migration
  def change
    remove_index :friendships, column: [:inbound_friend_id, :outbound_friend_id]
    add_index :friendships, [:inbound_friend_id, :outbound_friend_id], unique: true
  end
end
