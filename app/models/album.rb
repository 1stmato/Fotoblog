class Album < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  belongs_to :user
  validates :title, :description, presence: true

  def rating
    posts_with_rating = self.posts.select { |post| post.rated? } unless self.posts.nil?
    return 0 if posts_with_rating.blank?
    sum = 0
    posts_with_rating.each { |post| sum += post.rating}
    sum / posts_with_rating.size.to_f
  end
end
