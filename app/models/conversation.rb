class Conversation < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :messages

  def other_user(user)
    message_to_use = messages.first
    self.messages.each do |message|
      message_to_use = message
      break unless message.recipient_id == message.sender_id
    end

    if message_to_use.recipient_id == user.id
      User.find(message_to_use.sender_id)
    else
      User.find(message_to_use.recipient_id)
    end
  end
end
