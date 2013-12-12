class Photo < ActiveRecord::Base
  attr_accessible :photo_file, :user_id, :caption

  validates :photo_file, :user_id, presence: true

  has_attached_file :photo_file, :styles => {
    :big => "300X300>",
    :small => "100x100#"
  }

  belongs_to :user
end
