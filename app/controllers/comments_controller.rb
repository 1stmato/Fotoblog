class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    #render plain: params.inspect

    setup_comment.save
    redirect_to post_path(@post)
end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
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
    comment.likes = 0
    comment.dislikes = 0
    comment.body = params[:body]
    comment.post = @post
    return comment
  end

end
