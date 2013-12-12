class ChangeUserProfilePictureToPhoto < ActiveRecord::Migration
  def up
    remove_attachment :users, :profile_photo
    add_column :users, :profile_photo_id, :integer
  end

  def down
    drop_column :users, :profile_photo_id
    add_attachment :users, :profile_photo
  end
end
