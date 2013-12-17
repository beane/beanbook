class TagsController < ApplicationController
  def index
    @tags = User.find(params[:user_id]).tags
    if request.xhr?
      render partial: 'tags/index'
    else
      render :index
    end
  end

  def create
    tag = Tag.new(params[:tag])
    tag.tagger_id = current_user.id
    if tag.save
      flash[:notice] = ["Tag saved!"]
      # hopefully I will javascript this away
      redirect_to root_url
    else
      flash[:errors] = tag.errors.full_messages
      redirect_to root_url
    end
  end

  def destroy
    Tag.find(params[:id]).destroy
    redirect_to root_url
  end
end
