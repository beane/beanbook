class FeedsController < ApplicationController
  def show
    # sloppily includes the user's posts
    @feed_posts = (current_user.wallposts + current_user.authored_posts)
                    .sort_by { |post| (post.created_at) }.uniq
    render :feed
  end
end
