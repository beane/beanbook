class FriendshipsController < ApplicationController
  def create
    friendship = Friendship.new()
    friendship.inbound_friend_id = params[:user_id]
    friendship.outbound_friend_id = current_user.id
    if friendship.save
      flash[:notice] = ["You have a new friend!"]
      redirect_to user_url(params[:user_id])
    else
      flash[:errors] = friendship.errors.full_messages
      # temporary - eventually should render json
      redirect_to user_friends_url(current_user)
    end
  end

  def updates
  end

  def destroy
    friendship1 = Friendship.find(params[:id])

    friendship2 = Friendship
      .find_by_inbound_friend_id_and_outbound_friend_id(
        friendship1.outbound_friend_id,
        friendship1.inbound_friend_id
    )

    if friendship1 && friendship2
      # i would like to user a transaction
      # how can i raise and rescue errors?
      friendship1.destroy
      friendship2.destroy
      redirect_to user_friends_url(current_user)
    else
      flash[:errors] = ["We're sorry: something went wrong"]
      redirect_to root_url
    end
  end
end
