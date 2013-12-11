class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:create, :new]

  def create
    user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )
    if user
      log_in(user)
      flash[:notice] = ["Thanks for logging in!"]
      redirect_to root_url
    else
      flash[:errors] = ["Log in failed: You shall not pass!"]
      redirect_to new_session_url
    end
  end

  def new
    render :new
  end

  def destroy
    log_out!
    flash[:notice] = ["Bye for now!"]
    # add flash message to say good bye
    redirect_to new_session_url
  end
end
