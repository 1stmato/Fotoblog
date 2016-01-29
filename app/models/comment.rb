class Comment < ActiveRecord::Base
  has_ancestry
  belongs_to :post
  belongs_to :user
  belongs_to :Comment
  has_many :likes

  def self.toggle_valid_with_children(comment_id)
    comment = Comment.find(comment_id)
    c = Comment.where(ancestry: comment.id).update_all(:validated => !comment.validated)
    comment.update_attribute(:validated, !comment.validated)
    comment.update_attribute(:display, !comment.display)
    return c
  end

  def self.toggle_visible(comment_id)
    comment = Comment.find(comment_id)
    comment.update_attribute(:display, !comment.display)
  end
end
