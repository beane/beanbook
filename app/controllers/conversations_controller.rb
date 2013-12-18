class ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations
    render :index
  end

  def show
    @conversation = Conversation.find(params[:id])
  end
end
