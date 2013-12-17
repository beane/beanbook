class ConversationsController < ApplicationController
  def index
    @conversations = current_user.hashed_messages
    render :index
  end

  def show
    @conversation = Conversation.find(params[:id])
  end
end
