class FeedsController < ApplicationController
  def show
    # excludes current_user's posts
    @feed_posts = current_user.feed_posts.order(:created_at)
    render :feed
  end
end
