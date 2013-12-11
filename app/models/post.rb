class Post < ActiveRecord::Base
  attr_accessible :author_id, :recipient_id, :body

  validates :author_id, :recipient_id, :body, presence: true
  # validates :author_is_friends_with_recipient

  belongs_to(
    :recipient,
    class_name: "User",
    foreign_key: :recipient_id,
    primary_key: :id
  )

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )
end
