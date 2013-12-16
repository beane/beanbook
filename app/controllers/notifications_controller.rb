class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
    if request.xhr?
      render partial: 'notifications/index', locals: {notifications: @notifications}
    else
      render :index
    end
  end
end
