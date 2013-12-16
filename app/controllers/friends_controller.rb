class FriendsController < ApplicationController
  def index
    @friends = current_user.friends

    if request.xhr?

    else
      render :index
    end
  end
end
