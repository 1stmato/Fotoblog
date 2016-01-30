class CommentsController < ApplicationController

  load_and_authorize_resource
  # sqlite3 db/development.sqlite3


  def create
    @post = Post.find(params[:post_id])
    setup_comment.save
    if @post.allow_comments == "Approval"
      redirect_to post_path(@post), :flash => { :notice => "Your comment will be visible after validation !" }
    else
      redirect_to post_path(@post), :flash => { :notice => "Comment added" }
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  def like
    @post = Post.find(params[:post_id])
    if Like.where(comment_id: params[:comment_id]).where(user_id: current_user).count == 0
      like = Like.new
      comment = Comment.find(params[:comment_id])
      like.comment = comment
      like.user = current_user
      like.up = 1
      like.save
      # add to comment likes
      comment.increment!(:ups, 1)
    end
    redirect_to post_path(@post)
  end

  def dislike
    @post = Post.find(params[:post_id])
    if Like.where(comment_id: params[:comment_id]).where(user_id: current_user).count == 0
      like = Like.new
      comment = Comment.find(params[:comment_id])
      like.comment = comment
      like.user = current_user
      like.down = 1
      like.save
      # add to comment likes
      comment.decrement!(:downs, 1)
    end
    redirect_to post_path(@post)
  end

  def toggle_visible
    Comment.toggle_visible(params[:comment_id])
    redirect_to post_path(Post.find(params[:post_id]))
  end

  def toggle_valid
    Comment.toggle_valid_with_children(params[:comment_id])
    redirect_to post_path(Post.find(params[:post_id]))
  end


  private
  def comment_params
    params.require(:comment).permit(:body, :parent, :parent_id)
  end

  private
  def setup_comment()
    comment = Comment.new
    if params.has_key?(:parent_id)
      comment.parent = Comment.find(params[:parent_id])
    end
    comment.user = current_user
    @post.allow_comments == "Always" ? comment.display = true : comment.display = false
    comment.validated = false
    comment.ups = 0
    comment.downs = 0
    comment.body = comment_params[:body]
    comment.post = @post
    return comment
  end

end
