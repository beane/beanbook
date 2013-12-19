class CommentsController < ApplicationController

  #  eventually ajaxify

  def create # should take greater caution here for non-js requests
    comment = Comment.new(params[:comment])
    comment.user_id = current_user.id

    if request.xhr?
      if comment.save
        render partial: 'comments/show', locals: {comment: comment}
      else
        flash[:errors] = comment.errors.full_messages
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    if Comment.find(params[:id]).destroy && request.xhr?
      render json: {success: true}
    else
      redirect_to root_url
    end
  end
end
