class Project < ActiveRecord::Base
  has_many :authentications, :as => :authenticatable, :dependent => :destroy
  has_many :characters
  has_many :items
  has_many :broadcasts
  belongs_to :user
  
  has_many :authorized_users, :class_name => 'User', :through => :project_roles
  
  scope :by_newest, order("projects.created_at DESC")
  scope :by_oldest, order("projects.created_at ASC")
  scope :by_latest, order("projects.updated_at DESC")
  scope :newer_than, lambda { |*args| where("projects.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("projects.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  
  has_friendly_id :title
  
  has_attached_file :photo, 
                    :styles => { :medium => "332x224>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/character_default.jpg"
                    
  def can_edit?(check_user)
    return false if check_user.blank?
    return true if check_user == self.user
    return true if self.users.include?(check_user)
    false
  end
  
  def import_items(file)    
    FasterCSV.parse(file, :headers => true) do |col|
      character = self.characters.find_or_create_by_name(col[0])
      self.items.create(:content => col[1], :event_date_time => col[2], :location => col[3], :source=> col[4], :character_id => character.id)
    end  
  end

end