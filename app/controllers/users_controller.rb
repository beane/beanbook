class UsersController < ApplicationController
  skip_before_filter :authenticate, only: [:create, :new]
  before_filter :prevent_creation_when_logged_in, only: :new # maybe also create?

  def index
    @users = User.all
    if request.xhr?
      render partial: 'users/index', locals: {users: @users}
    else
      render :index
    end
  end

  def new
    render :new
  end

  def edit
    if request.xhr?
      render partial: 'users/edit'
    else
      render :edit
    end
  end

  def create
    user = User.new(params[:user])
    if user.save
      log_in(user)
      flash[:notice] = ["Welcome to beanbook!"]
      redirect_to root_url
    else
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def show
    @user = User.find(params[:id])
    @wallposts = @user.wallposts.order("created_at DESC")
    if request.xhr?
      render partial: 'users/show', locals: {wallposts: @wallposts, user: @user}
    else
      render :show
    end
  end

  def update
    user = current_user
    if user.update_attributes(params[:user])
      flash[:notice] = ["You successfully updated your profile!"]
    else
      flash[:errors] = user.errors.full_messages
    end
    redirect_to user_url(user)
  end
end
