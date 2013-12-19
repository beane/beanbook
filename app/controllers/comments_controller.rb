class CommentsController < ApplicationController

  #  eventually ajaxify

  def create
    comment = Comment.new(params[:comment])
    comment.user_id = current_user.id

    if comment.save

    else
      flash[:errors] = comment.errors.full_messages
    end

    redirect_to root_url
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to root_url
  end
end
