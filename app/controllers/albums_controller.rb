class AlbumsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @albums = Album.where(user_id: current_user.id).order('updated_at DESC')
  end

  def new
    @album = Album.new
  end

  def edit
    @album = Album.find(params[:id])
  end

  def create
    @album = Album.new(album_params)
    @album.user = current_user
    if @album.save
      redirect_to '/albums'
    else
      render 'new'
    end
  end

  def update
    @album = Album.find(params[:id])
    if @album.update(album_params)
      redirect_to '/albums'
    else
      render 'edit'
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    redirect_to '/albums'
  end

  private

  def album_params
    params.require(:album).permit(:title, :description)
  end
end
