class Photo < ActiveRecord::Base
  attr_accessible :photo_file, :user_id, :caption

  validates :photo_file, :user_id, presence: true

  has_attached_file :photo_file, :styles => {
    :big => "300X300>",
    :small => "100x100#"
  }

  belongs_to :user

  # this might be broken
  # has_many(
  #   :profile_uses,
  #   class_name: "User",
  #   foreign_key: :profile_picture_id
  # )

  has_many :tags, as: :taggable, dependent: :destroy

  has_many(
    :tagged_users,
    through: :tags,
    source: :taggee
  )
end
