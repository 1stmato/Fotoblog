class User < ActiveRecord::Base
  ratyrate_rater
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?(user)
     user.admin == true ? true : false
  end
end
