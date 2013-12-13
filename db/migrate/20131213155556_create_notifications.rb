class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.references :notifiable, polymorphic: true

      t.timestamps
    end

    add_index :notifications, :recipient_id
  end
end
