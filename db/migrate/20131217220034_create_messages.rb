class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :conversation_id
      t.integer :sender_id
      t.integer :recipient_id
      t.text :body

      t.timestamps
    end

    add_index :messages, :conversation_id
    add_index :messages, :sender_id
  end
end
