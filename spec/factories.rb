Factory.define :item do |f|
  f.source { Factory.next(:name) }
  f.content { Factory.next(:description) }
  f.character {|a| a.association(:character) }
  f.project {|a| a.association(:project) }
  f.photo fixture_file_upload('../../public/images/profile_default.jpg', 'image/jpg')
end

Factory.define :character do |f|
  f.project {|a| a.association(:project) }
  f.name { Factory.next(:name) }
  f.creator_name { Factory.next(:name) }
  f.bio { Factory.next(:description) }
  f.photo fixture_file_upload('../../public/images/profile_default.jpg', 'image/jpg')
end

Factory.define :project do |f|
  f.name { Factory.next(:title) }
  f.bio { Factory.next(:description) }
  f.photo fixture_file_upload('../../public/images/profile_default.jpg', 'image/jpg')
end

Factory.define :authentication do |f|
  f.character {|a| a.association(:character) }
  f.provider { Factory.next(:name) }
  f.uid { Factory.next(:uri) }
  t.timestamps  
end