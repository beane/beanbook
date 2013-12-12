class PhotosController < ApplicationController
  def index
    @photos = Photo.where({user_id: params[:user_id]})
    render :index
  end

  def show
    @photo = Photo.find(params[:id])
    render :show
  end

  def edit
    @photo = Photo.find(params[:id])
    render :edit
  end

  def update
    photo = Photo.find(params[:id])
    if photo.update_attributes(params[:photo])
      flash[:notice] = ["Photo updated!"]
      redirect_to user_photo_url(params[:user_id], photo)
    else
      flash[:errors] = photo.errors.full_messages
      redirect_to user_photo_url(params[:user_id], photo)
    end
  end
end
