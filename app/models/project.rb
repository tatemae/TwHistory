class Project < ActiveRecord::Base
  include RemoteFileMethods
  
  has_many :characters, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :broadcasts, :dependent => :destroy
  belongs_to :user
  
  has_many :project_roles
  has_many :authorized_users, :through => :project_roles, :source => 'user'
  
  scope :by_newest, order("projects.created_at DESC")
  scope :by_oldest, order("projects.created_at ASC")
  scope :by_latest, order("projects.updated_at DESC")
  scope :newer_than, lambda { |*args| where("projects.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("projects.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  scope :featured, where("projects.featured_at IS NOT NULL")
  scope :by_featured, order("projects.featured_at DESC")
  
  has_friendly_id :title, :use_slug => true
  
  has_attached_file :photo, 
                    :styles => { :medium => "332x224>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/character_default.jpg"
  
  attr_protected :created_at, :updated_at, :featured_at
  
  searchable do
    string :title
    string :location
    text :title
    text :location
    text :description, :more_like_this => true
  end
                                      
  def can_edit?(check_user)
    return false if check_user.blank?
    return true if check_user == self.user
    return true if self.authorized_users.include?(check_user)
    false
  end
  
  def import_items(file)
    file = file.tempfile # have to get to the actual file inside the upload
    results = []
    items = []
    return [items, results] if file.nil?
    has_headers = false
    first_line = file.readlines[0]
    if first_line && first_line.include?('Event Date')
      has_headers = true
    end
    file.rewind
    FasterCSV.parse(file, :headers => has_headers) do |row|
      character = self.characters.find_or_create_by_name(row[2])
      character.photo_url = row[6] if character.photo_file_name.blank? && row[6]
      if !character.save
        results << "FAILED to save character image for character id: #{character.id}. Error: #{character.errors.full_messages.to_sentence}"
      end
      begin
        item = {:event_date_time => DateTime.parse("#{row[0]} #{row[1]}"), :character_id => character.id, :content => row[3]}
        item[:location] = row[4] if row[4]
        item[:source] = row[5] if row[5]
        new_item = self.items.build(item)
        if !new_item.save
          results << "FAILED: #{row}"
        else
          items << new_item
        end
      rescue => ex
        results << "FAILED: #{row}. Error was: #{ex}"
      end
    end
    [items, results]
  rescue => ex
    t = 0
    debugger
  end

  def authentication_name
    self.title
  end
  
  def next_broadcast
    @next_broadcast ||= (self.broadcasts.in_progress.by_start || self.broadcasts.future.by_start).first
  end
  
  def last_broadcast
    @last_broadcast ||= (self.broadcasts.past.by_old).first
  end
end