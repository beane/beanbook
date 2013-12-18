class ConversationUser < ActiveRecord::Base
  attr_accessible :user_id, :conversation_id

  belongs_to :conversation, inverse_of: :conversation_users
  belongs_to :user, inverse_of: :conversation_users
end
