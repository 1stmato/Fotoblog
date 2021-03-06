class PostsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @posts = Post.all.order('updated_at DESC')
    @best_posts = Post.all.sort_by(&:rating).reverse
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
  end

  def new
    @post = Post.new
    @albums = Album.where(user_id: current_user.id)
  end

  def edit
    @post = Post.find(params[:id])
    @albums = Album.where(user_id: @post.user_id)
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @albums = Album.where(user_id: current_user.id)
    if @post.save
      redirect_to '/'
    else
      render 'new'
    end
  end

  # rubocop:disable Metrics/AbcSize
  def update
    @post = Post.find(params[:id])
    @albums = Album.where(user_id: @post.user_id)
    # rubocop:disable Style/SymbolProc
    old_tags = @post.tags.map { |tag| tag.name }.join(' ')
    # rubocop:enable Style/SymbolProc
    if @post.update(post_params)
      @post.check_tags(old_tags.split(/[\s,]+/))
      @post.update_attributes(album_id: post_params['album_name'])
      redirect_to '/'
    else
      render 'edit'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to '/'
  end

  # rubocop:disable Metrics/AbcSize
  def filter_best
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
    @posts = Post.joins(:tags).where('tags.name' => params[:tag_name]).sort_by(&:rating).reverse
    @active_tag = params[:tag_name]
    render :list_of_posts
  end
  # rubocop:enable Metrics/AbcSize


  # rubocop:disable Metrics/AbcSize
  def filter
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
    @posts = Post.joins(:tags).where('tags.name' => params[:tag_name]).order('updated_at DESC')
    @active_tag = params[:tag_name]
    render :list_of_posts
  end
  # rubocop:enable Metrics/AbcSize

  def show
    @post = Post.find(params[:id])
  end

  def best_posts
    @posts = Post.all.sort_by(&:rating).reverse
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
    render :list_of_posts
  end

  def newest_posts
    @posts = Post.all.order('updated_at DESC')
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
    render :list_of_posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :photo, :tags_string, :allow_comments, :album_name)
  end
end
