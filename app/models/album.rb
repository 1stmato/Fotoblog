class Album < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  belongs_to :user

  validates :title, :description, presence: true
end
