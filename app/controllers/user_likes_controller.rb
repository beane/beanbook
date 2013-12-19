class UserLikesController < ApplicationController
  # these will eventually be ajax requests

  def create
    @like = UserLike.new(params[:like])
    @like.liker_id = current_user.id

    if @like.save
      redirect_to root_url
    else
      flash[:errors] = @like.errors.full_messages
      redirect_to root_url
    end
  end

  def destroy
    UserLike.find(params[:id]).destroy
    redirect_to root_url
  end
end
