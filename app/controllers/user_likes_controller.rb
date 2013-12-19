class UserLikesController < ApplicationController
  def update
    @like = UserLike.new
    @like.liker_id = current_user.id
    @like.likable_type = params[:user_id].capitalize # hackety hack
    @like.likable_id = params[:id]

    if @like.save
      if request.xhr?
        render json: {increment: 1}
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    if UserLike.find_by_likable_id_and_likable_type_and_liker_id(
      params[:id],
      params[:user_id].capitalize,
      current_user.id
    ).destroy
      if request.xhr?
        render json: {increment: -1}
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end
end
