class UsersController < ApplicationController
  skip_before_filter :authenticate, only: [:create, :new]
  before_filter :prevent_creation_when_logged_in, only: :new # maybe also create?

  def index
    @users = User.all
    render :index
  end

  def new
    render :new
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
    @wallposts = @user.wallposts.order(:created_at)
    render :show
  end
end
