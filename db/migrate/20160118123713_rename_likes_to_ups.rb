class RenameLikesToUps < ActiveRecord::Migration
  def change
    rename_column :comments, :likes, :ups
    rename_column :comments, :dislikes, :downs
  end
end
