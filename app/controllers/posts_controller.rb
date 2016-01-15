class PostsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @posts = Post.all.order('updated_at DESC')
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      tags_string = (params['post']['tags_string']).to_s
      tags = parse_tags(tags_string)
      @post.update_attributes(tags: tags)
      redirect_to '/'
    else
      render 'new'
    end
  end

  # rubocop:disable Metrics/AbcSize
  def update
    @post = Post.find(params[:id])
    # rubocop:disable Style/SymbolProc
    old_tags = @post.tags.map { |tag| tag.name }.join(' ')
    # rubocop:enable Style/SymbolProc
    if @post.update(post_params)
      tags_string = (params['post']['tags_string']).to_s
      tags = parse_tags(tags_string)
      @post.update_attributes(tags: tags)
      deleted_tags = old_tags.split(/[\s,]+/) - tags_string.split(/[\s,]+/)
      updated_tags = deleted_tags | tags_string.split(/[\s,]+/) - old_tags.split(/[\s,]+/)
      @post.touch unless updated_tags.blank?
      deleted_tags.each { |tag| Tag.destroy_all('name' => tag) if Post.joins(:tags).where('tags.name' => tag).empty? }
      redirect_to '/'
    else
      render 'edit'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    @post = Post.find(params[:id])

    @post.tags.each do |tag|
      @post.tags.delete(tag)
      # puts Post.joins(:tags).where('tags.name' => tag[:name]).empty?
      Tag.destroy(tag) if Post.joins(:tags).where('tags.name' => tag[:name]).empty?
    end
    @post.destroy

    redirect_to '/'
  end

  # rubocop:disable Metrics/AbcSize
  def filter
    # rubocop:disable Metrics/LineLength
    @tags = Tag.all.sort { |tag2, tag1| Post.joins(:tags).where('tags.name' => tag1[:name]).count <=> Post.joins(:tags).where('tags.name' => tag2[:name]).count }
    # rubocop:enable Metrics/LineLength
    @posts = Post.joins(:tags).where('tags.name' => params[:tag_name]).order('updated_at DESC')
    render :index
  end
  # rubocop:enable Metrics/AbcSize

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :photo, :tags_string, :comments)
  end

  def parse_tags(tags_string)
    tags = tags_string.split(/[\s,]+/)
    tags.uniq.map! do |name|
      Tag.find_or_create_by(name: name)
    end
  end
end
