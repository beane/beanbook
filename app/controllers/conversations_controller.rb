class ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations
    render :index
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def new
    @conversation = Conversation.new
    # @conversation.messages.build
    render :new
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
        redirect_to conversation_url(c)
      rescue
        flash[:errors] = c.errors.full_messages + c.messages.first.errors.full_messages
        redirect_to new_conversation_url
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
      flash[:notice] = message
    else
      flash[:errors] = ["Something went wrong :-()"]
    end

    redirect_to conversation_url(c)
  end
end
