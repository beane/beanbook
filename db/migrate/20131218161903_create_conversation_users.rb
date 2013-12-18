class CreateConversationUsers < ActiveRecord::Migration
  def change
    create_table :conversation_users do |t|
      t.integer :conversation_id
      t.integer :user_id

      t.timestamps
    end

    add_index :conversation_users, :conversation_id
    add_index :conversation_users, :user_id
  end
end
