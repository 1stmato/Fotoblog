class User < ActiveRecord::Base
  ratyrate_rater
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  #def admin?(user)
  #   user.admin == true ? true : false
  #end

  #paperclip
  has_attached_file :avatar, styles: { medium: "128x128>", thumb: "48x48>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def self.users_post_rating(user_id)
    q = "select p.id, r.stars, r.rateable_id, p.title, p.description, p.photo_file_name, p.photo_content_type, p.description
   FROM rates r, rating_caches rc, posts p where r.rater_id = #{user_id} and r.rateable_id = rc.cacheable_id and p.id = rc.cacheable_id;"
    ActiveRecord::Base.connection.execute(q)
  end

end
