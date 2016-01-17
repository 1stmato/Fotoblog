class Comment < ActiveRecord::Base
  has_ancestry
  belongs_to :post
  belongs_to :user
  belongs_to :Comment
end
