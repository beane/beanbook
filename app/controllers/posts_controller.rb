class PostsController < ApplicationController
  def create
    post = Post.new(params[:post])
    post.author_id = current_user.id
    post.recipient_id = params[:user_id]

    if request.xhr?
      if post.save
        render partial: 'posts/show', locals: {post: post}
      else
        flash[:errors] = post.errors.full_messages
        # this doesn't really do anything
        render json: post
      end
    else
      redirect_to user_url(params[:user_id])
    end
  end

  def show
    @post = Post.find(params[:id])
    @recipient = @post.recipient

    if request.xhr?
      render partial: 'posts/show', locals: {post: @post}
    else
      render :show
    end
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
