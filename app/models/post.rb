class Post < ActiveRecord::Base
  ratyrate_rateable
  has_and_belongs_to_many :tags
  belongs_to :user
  attr_accessor :tags_string
  attr_accessor :body_file_name
  attr_accessor :body_content_type
  validates :title, :description, :comments, presence: true

  # rubocop:disable Metrics/LineLength
  has_attached_file :photo, styles: { medium: '800x600>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  # rubocop:enable Metrics/LineLength


  # rubocop:disable Style/RegexpLiteral
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  # rubocop:enable Style/RegexpLiteral

  validates :photo, attachment_presence: true

  validates :tags_string, presence: { message: 'must have at least one tag' }
end
