class AddCommentsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :allow_comments, :string
  end
end
