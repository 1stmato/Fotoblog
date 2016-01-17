class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    #render plain: comment_params[:body].inspect
    setup_comment.save
    redirect_to post_path(@post)
end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to posts_path(@post)
  end

  private
  def comment_params
    params.permit(:body, :parent)
  end

  private
  def setup_comment()
    comment = Comment.new
    if comment_params.has_key?(:parent)
      comment.Comment = Comment.find(comment_params[:parent])
    end
    comment.user = current_user
    @post.allow_comments == "Always" ? comment.display = true : comment.display = false
    comment.validated = false
    comment.likes = 0
    comment.dislikes = 0
    comment.body = comment_params[:body]
    comment.post = @post
    return comment
  end

end
