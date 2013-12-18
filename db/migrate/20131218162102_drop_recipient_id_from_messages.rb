class DropRecipientIdFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :recipient_id
  end

  def down
    add_column :messages, :recipient_id, :integer
  end
end
