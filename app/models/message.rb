class Message < ActiveRecord::Base
  attr_accessible :body, :conversation_id, :sender_id

  validates :body, :conversation_id, :sender_id, presence: true

  belongs_to(
    :sender,
    class_name: "User",
    foreign_key: :sender_id
  )

  belongs_to :conversation
end
