class FriendsController < ApplicationController
  def index
    @friends = current_user.friends

    if request.xhr?
      render partial: 'friends/index', locals: {friends: @friends}
    else
      render :index
    end
  end
end
