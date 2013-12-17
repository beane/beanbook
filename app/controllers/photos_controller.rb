class PhotosController < ApplicationController
  def index
    @photos = Photo.where({user_id: params[:user_id]}).order(:created_at)
    if request.xhr?
      render partial: 'photos/index', locals: {photos: @photos}
    else
      render :index
    end
  end

  def new
    if request.xhr?
      render partial: 'photos/new'
    else
      render :new
    end
  end

  def create
    photo = Photo.new(params[:photo])
    photo.user_id = current_user.id
    if photo.save
      flash[:notice] = ["Photo uploaded successfully!"]
      redirect_to user_photo_url(params[:user_id], photo)
    else
      flash[:errors] = photo.errors.full_messages
      redirect_to user_photos_url(current_user)
    end
  end

  def show
    @user = User.find(params[:user_id])
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

  def destroy
    photo = Photo.find(params[:id])
    photo.destroy
    flash[:notice] = ["Photo deleted"]
    redirect_to user_photos_url(params[:user_id])
  end
end
