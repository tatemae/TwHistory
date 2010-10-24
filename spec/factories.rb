Factory.define :item do |f|
  f.source { Factory.next(:name) }
  f.content { Factory.next(:description) }
  f.character {|a| a.association(:character) }
  f.project {|a| a.association(:project) }
  f.event_date_time DateTime.now
end

Factory.define :character do |f|
  f.project {|a| a.association(:project) }
  f.name { Factory.next(:name) }
  f.bio { Factory.next(:description) }
  f.photo fixture_file_upload("#{::Rails.root}/public/images/character_default.jpg", 'image/jpg')
end

Factory.define :project do |f|
  f.user {|a| a.association(:user) }
  f.title { Factory.next(:title) }
  f.description { Factory.next(:description) }
  f.photo fixture_file_upload("#{::Rails.root}/public/images/project_default.jpg", 'image/jpg')
end

Factory.define :authentication do |f|
  f.character {|a| a.association(:character) }
  f.provider { Factory.next(:name) }
  f.uid { Factory.next(:uri) }
end

Factory.define :broadcast do |f|
  f.project {|a| a.association(:project) }
  f.authentication {|a| a.association(:authentication) }
  f.start_at DateTime.now
end

Factory.define :sheduled_item do |f|
  f.broadcast {|a| a.association(:broadcast) }
  f.item {|a| a.association(:item) }
  f.send_at DateTime.now
end