class FeedsController < ApplicationController
  def show
    # sloppily includes the user's posts
    @feed_posts = (current_user.wallposts + current_user.authored_posts).sort.uniq
    render :feed
  end
end
