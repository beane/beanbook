class PostsController < ApplicationController
  def create
    post = Post.new(params[:post])
    post.author_id = current_user.id
    post.recipient_id = params[:user_id]


    if post.save
      if request.xhr?
        render partial: 'posts/show', locals: {post: post}
      else
        # flash[:errors] = post.errors.full_messages
        # this doesn't really do anything
        redirect_to user_url(params[:user_id])
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
    if request.xhr?
      render(partial: 'posts/form', locals: {post: @post, user: User.find(params[:user_id])})
    else
      render :edit
    end
  end

  def update # okay this breaks hard if there's no JS
    post = Post.find(params[:id])
    post.author_id = current_user.id # for the model validation

    if request.xhr?
      if post.update_attributes(params[:post])
        render partial: 'posts/show', locals: {post: post}
      else
        flash[:notice] = ["Your post has been updated."]
        redirect_to user_url(params[:user_id])
      end
    else
      # maybe change all the flashes to flash.now
      flash[:errors] = post.errors.full_messages
      render partial: 'layouts/errors'
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
