class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.attachment :photo_file, null: false
      t.integer :user_id, null: false
      t.string :caption

      t.timestamps
    end

    add_index :photos, :user_id
  end
end
