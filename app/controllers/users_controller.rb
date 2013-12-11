class UsersController < ApplicationController
  skip_before_filter :authenticate, only: [:create, :new]

  def create
    user = User.new(params[:user])
    if user.save
      log_in(user)
      flash[:notice] = ["Welcome to beanbook!"]
      redirect_to user_url(user)
    else
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def show
    @user = current_user
    # do i need to sort the wallposts by created at?
    @wallposts = @user.wallposts.order(:created_at)
    render :show
  end

  def feed
    # need friendships first
    render :feed
  end
end
