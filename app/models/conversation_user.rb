class ConversationUser < ActiveRecord::Base
  attr_accessible :user_id, :conversation_id

  belongs_to :conversation
  belongs_to :user
end
