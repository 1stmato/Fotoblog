module CommentsHelper
  def get_comment_color(comment)
    color = ""
    if comment.user_id == current_user.id
      color = "owner"
    end
    if (can? :manage, @post) && comment.validated == false && @post.allow_comments == "Approval"
      color = "invalid"
    elsif (can? :manage, @post) && comment.display == false
      color = "disabled"
    end
    return color
  end
end