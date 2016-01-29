class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts

  def to_param
    name
  end

  def self.top
    select("tags.id, tags.name, count(posts.id) AS posts_top")
        .joins(:posts)
        .group("tags.id")
        .order("posts_top DESC")
  end
end
