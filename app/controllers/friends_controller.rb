class FriendsController < ApplicationController
  def index
    @friends = current_user.friends
    # @pending_friends = current_user.
    render :index
  end
end
