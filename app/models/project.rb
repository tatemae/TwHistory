class Project < ActiveRecord::Base
  
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
  
  has_friendly_id :title, :use_slug => true
  
  has_attached_file :photo, 
                    :styles => { :medium => "332x224>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/character_default.jpg"
  
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
    return true if self.users.include?(check_user)
    false
  end
  
  def import_items(file)
    results = []
    items = []
    FasterCSV.parse(file, :headers => true) do |row|
      character = self.characters.find_or_create_by_name(row[2])
      item = {:event_date_time => DateTime.parse("#{row[0]} #{row[1]}"), :character_id => character.id, :content => row[3]}
      item[:location] = row[4] if row[4]
      item[:source] = row[5] if row[5]
      new_item = self.items.build(item)
      if !new_item.save
        results << "FAILED: #{row.join(',')}"
      else
        items << new_item
      end
    end
    [items, results]
  end

  def authentication_name
    self.title
  end
  
end