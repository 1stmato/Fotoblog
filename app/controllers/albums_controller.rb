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

  def posts_list
    @posts = Post.where(user_id: current_user.id).order('updated_at DESC')
    @album = Album.find(params[:album_id])
  end

  def add_post
    @album = Album.find(params[:album_id])
    params['album']['post_ids'].each do |post_id|
      p = Post.update(post_id, album_id: params[:album_id])
      puts post_id
      puts params[:album_id]
      puts p.album_id
    end
    redirect_to '/albums/' + params[:album_id]
  end

  private

  def album_params
    params.require(:album).permit(:title, :description)
  end
end
