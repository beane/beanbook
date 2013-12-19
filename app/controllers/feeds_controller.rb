class FeedsController < ApplicationController
  def show
    # sloppily includes the user's posts
    # remember to include friend's posts
    @feed_posts = (current_user.wallposts + current_user.authored_posts)
                    .sort_by { |post| (post.created_at) }.uniq.reverse
    if request.xhr?
      render partial: 'feeds/feed', locals: {feed_posts: @feed_posts}
    else
      render :feed
    end
  end
end
