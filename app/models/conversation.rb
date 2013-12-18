class Conversation < ActiveRecord::Base
  attr_accessible :user_ids, :message_attributes

  has_many :messages

  has_many :conversation_users, inverse_of: :conversation

  has_many :users, through: :conversation_users, inverse_of: :conversations
end
