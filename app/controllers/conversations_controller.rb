class ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations
    render :index
  end

  def show
    @conversation = Conversation.find(params[:id])
    if request.xhr?
      render partial: 'conversations/show', locals: {conversation: @conversation}
    else
      render :show
    end
  end

  def create
    # remember to check for blank params[:user_ids]
    Conversation.transaction do
      begin
        # remember to figure out how to find existing conversation with
        # the same user_ids
        c = Conversation.create!
        c.user_ids = (params[:conversation][:user_ids] + [current_user.id])
        c.messages.create!(params[:message_attributes].merge(sender_id: current_user.id))
        c.save!
        flash[:notice] = ["Message sent!"]

        if request.xhr?
          render partial: 'conversations/show', locals: {conversation: c}
        else
          redirect_to conversation_url(c)
        end
      rescue
        flash[:errors] = c.errors.full_messages
        redirect_to conversations_url
      end
    end
  end

  def edit
    render :edit
  end

  def update
    # this adds new messages to the conversation
    # maybe adds new users
    c = Conversation.find(params[:id])
    c.user_ids += params[:conversation][:user_ids] if params[:conversation]

    unless params[:message_attributes][:body].blank?
      c.messages.create(
        params[:message_attributes].merge(sender_id: current_user.id)
      )
    end

    if params[:conversation] && !params[:message_attributes][:body].blank?
      message = ["User added and message sent!"]
    elsif params[:conversation]
      message = ["User added!"]
    elsif !params[:message_attributes][:body].blank?
      message = ["Message sent!"]
    else
      message = ["You didn't do anything"]
    end

    if c.save
      if request.xhr?
        render partial: 'conversations/show', locals: {conversation: c}
      else
        flash[:notice] = message
      end
    else
      flash[:errors] = ["Something went wrong :-("]
      redirect_to conversation_url(c)
    end
  end
end
