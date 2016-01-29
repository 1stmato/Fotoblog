class AlbumsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @albums = current_user.admin? ? Album.all : Album.where(user_id: current_user.id).order('updated_at DESC')
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

  def posts
    @album = Album.find(params[:id])
    @posts = Post.where(user_id: @album.user_id).where.not(album_id: @album.id).order('updated_at DESC') if request.get?
    if request.patch?
      album_params['post_ids'].select { |id| id != '-1' }.each do |post_id|
        Post.find(post_id).update_attribute('album_id', @album.id)
      end
      redirect_to '/albums/' + params[:id]
    end

  end

  private

  def album_params
    params.require(:album).permit(:title, :description, post_ids: [])
  end
end
