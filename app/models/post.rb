class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  attr_accessor :tags_string
  validates :author, :title, :body, presence: true
  validates :tags_string, presence: { message: 'must have at least one tag' }
end
