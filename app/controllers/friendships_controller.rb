class FriendshipsController < ApplicationController
  def create
    friendship = Friendship.new()
    friendship.inbound_friend_id = params[:user_id]
    friendship.outbound_friend_id = current_user.id
    if friendship.save
      flash[:notice] = ["Friend request sent!"]

      if request.xhr?
        render partial: 'friends/index', locals: {friends: current_user.friends}
      else
        redirect_to user_url(params[:user_id])
      end
    else
      flash[:errors] = friendship.errors.full_messages
      # temporary - eventually should render json
      redirect_to user_friends_url(current_user)
    end
  end

  # handles pending requests
  def update
    friendship = Friendship.find(params[:id])
    new_friendship = Friendship.new(
      inbound_friend_id: friendship.outbound_friend_id,
      outbound_friend_id: friendship.inbound_friend_id
    )

    if new_friendship.save

      if request.xhr?
        render partial: 'friends/index', locals: {friends: current_user.friends}
      else
        flash[:notice] = ["You have a new friend!"]
        redirect_to user_url(new_friendship.inbound_friend_id)
      end
    else
      flash[:errors] = new_friendship.errors.full_messages
      redirect_to user_friends_url(current_user)
    end
  end

  def destroy
    friendship1 = Friendship.find(params[:id])

    friendship2 = Friendship
      .find_by_inbound_friend_id_and_outbound_friend_id(
        friendship1.outbound_friend_id,
        friendship1.inbound_friend_id
    )

    if friendship1 && friendship2
      # i would like to use a transaction
      # how can i raise and rescue errors?
      friendship1.destroy
      friendship2.destroy
    elsif friendship1
      friendship1.destroy
    elsif friendship2
      friendship2.destory
    else
      flash[:errors] = ["We're sorry: something went wrong"]
    end

    if request.xhr?
      render partial: 'friends/index', locals: {friends: current_user.friends}
    else
      redirect_to user_friends_url(current_user)
    end
  end
end
