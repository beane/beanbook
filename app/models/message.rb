class Message < ActiveRecord::Base
  attr_accessible :body, :conversation_id, :recipient_id, :sender_id

  validate :body, :conversation_id, :recipient_id, :sender_id, presence: true

  belongs_to(
    :sender,
    class_name: "User",
    foreign_key: :sender_id
  )

  belongs_to(
    :recipient,
    class_name: "User",
    foreign_key: :recipient_id
  )

  belongs_to :conversation
end
