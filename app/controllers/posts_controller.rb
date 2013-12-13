class PostsController < ApplicationController
  def create
    post = Post.new(params[:post])
    post.author_id = current_user.id
    post.recipient_id = params[:user_id]
    if post.save
      # render json: post
      redirect_to user_url(params[:user_id])
    else
      flash[:errors] = post.errors.full_messages
      # what to send back?
      # i don't want to refresh the page
      render json: post
    end
  end

  def show
    @post = Post.find(params[:id])
    @recipient = @post.recipient
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    post = Post.find(params[:id])
    if post.update_attributes(params[:post])
      flash[:notice] = ["Your post has been updated."]
      redirect_to user_url(params[:user_id])
    else
      # maybe change all the flashes to flash.now
      flash[:errors] = post.errors.full_messages
      redirect_to edit_user_post_url(current_user, post)
    end
  end

  def destroy
    post = Post.find(params[:id])
    id = post.recipient_id
    post.destroy
    flash[:notice] = ["Your post has been deleted."]
    redirect_to user_url(id)
  end
end
