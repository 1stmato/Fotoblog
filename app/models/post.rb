class Post < ActiveRecord::Base
  ratyrate_rateable 'quality'
  has_and_belongs_to_many :tags
  belongs_to :user
  belongs_to :album
  has_many :comments, dependent: :destroy
  attr_accessor :tags_string
  attr_accessor :album_name
  attr_accessor :body_file_name
  attr_accessor :body_content_type
  validates :title, :description, :allow_comments, :album_name, presence: true

  # rubocop:disable Metrics/LineLength
  has_attached_file :photo, styles: { medium: '800x600>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  # rubocop:enable Metrics/LineLength


  # rubocop:disable Style/RegexpLiteral
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  # rubocop:enable Style/RegexpLiteral

  validates :photo, attachment_presence: true

  validates :tags_string, presence: { message: 'must have at least one tag' }

  before_create :parse_tags, :parse_album, prepend: true
  #before_update :check_tags, prepend: true
  before_destroy :remove_tags, prepend: true
  def check_tags(old_tags)
      # rubocop:disable Style/SymbolProc
      #self.tags.each {|tag| puts tag.name}
      #old_tags = self.tags.dup
      #self.tags.each { |tag| old_tags.append(tag.name) }#.join(' ')
      # rubocop:enable Style/SymbolProc
      #old_tags.each {|tag| puts tag.name}
      parse_tags

      deleted_tags = old_tags - tags_string.split(/[\s,]+/)
      #updated_tags = deleted_tags | tags_string.split(/[\s,]+/) - old_tags
      #self.touch unless updated_tags.blank?
      puts 'Deleted tags: ' + deleted_tags.to_s

      #self.tags.each {|tag| puts tag.name}
      #updated_tags = deleted_tags | self.tags - old_tags
      #parse_tags
      #self.touch unless updated_tags.blank?
      deleted_tags.each { |tag| Tag.destroy_all('name' => tag) if Post.joins(:tags).where('tags.name' => tag).empty? }
      #self.update_attributes(album_id: post_params['album_name'])
  end

  def rated?
    not(self.average.nil?)
  end

  def rating
    self.average.nil? ? 0 : self.average.avg
  end

  private

    def remove_tags
      tags.each do |tag|
        tags.delete(tag)
        Tag.destroy(tag) if Post.joins(:tags).where('tags.name' => tag[:name]).empty?
      end
    end

    def parse_tags
      tag_strings = tags_string.split(/[\s,]+/)
      tag_strings.each {|tag| puts tag}
      self.tags = []
      tag_strings.uniq.each { |name| self.tags.append(Tag.find_or_create_by(name: name)) }
      #self.tags = tag_strings
    end

    def parse_album
      if(album_name == '-1')
        album = Album.new
        album.update_attributes(:title => 'Default', :description => 'Default album for unsorted photos', :user_id => self.user.id)
        album.save
        self.album_id = album.id
      else
        self.album_id = self.album_name
      end
    end

end
