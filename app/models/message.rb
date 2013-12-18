class Message < ActiveRecord::Base
  attr_accessible :body, :conversation_id, :sender_id

  validates :body, :conversation_id, :sender_id, presence: true
  validate :can_only_send_if_member_of_conversation

  after_create :notify

  belongs_to(
    :sender,
    class_name: "User",
    foreign_key: :sender_id
  )

  belongs_to :conversation

  has_many :tags, as: :taggable, dependent: :destroy

  private
    def can_only_send_if_member_of_conversation
      unless conversation.user_ids.include? sender_id
        errors.add(:sender_id, "must be a member of the conversation")
      end
    end

    def notify
      sender_name = User.find(sender_id).name
      (self.conversation.user_ids - [sender_id]).each do |user_id|
        Notification.create(
          recipient_id: user_id,
          sender_id: sender_id,
          notifiable_id: id,
          notifiable_type: "Message",
          message: "#{sender_name} sent you a message!"
        )
      end
    end
end
