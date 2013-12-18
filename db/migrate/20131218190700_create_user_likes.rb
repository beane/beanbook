class CreateUserLikes < ActiveRecord::Migration
  def change
    create_table :user_likes do |t|
      t.references :likable, polymorphic: true
      t.integer :liker_id

      t.timestamps
    end

    add_index :user_likes, :likable_id
  end
end
