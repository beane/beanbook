class Message < ActiveRecord::Base
  attr_accessible :body, :conversation_id, :sender_id

  validates :body, :conversation_id, :sender_id, presence: true
  validate :can_only_send_if_member_of_conversation

  belongs_to(
    :sender,
    class_name: "User",
    foreign_key: :sender_id
  )

  belongs_to :conversation

  private
    def can_only_send_if_member_of_conversation
      unless conversation.user_ids.include? sender_id
        errors.add(:sender_id, "must be a member of the conversation")
      end
    end
end
