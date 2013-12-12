class PhotosController < ApplicationController
  def index
    @photos = Photo.where({user_id: params[:user_id]})
    render :index
  end

  def show
    @photo = Photo.find(params[:id])
    render :show
  end
end
