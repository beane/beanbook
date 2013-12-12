class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :taggable, polymorphic: true
      # positions are only for photo tags
      t.integer :x_pos
      t.integer :y_pos
      t.integer :tagger_id
      t.integer :taggee_id # wow that's a bad name

      t.timestamps
    end

    add_index :tags, [:taggable_id, :taggable_type]
  end
end
