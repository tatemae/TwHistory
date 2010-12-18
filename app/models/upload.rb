class Upload < ActiveRecord::Base

  include Uploader::Models::Upload
  
  validates_attachment_presence :local
  validates_attachment_size :local, :less_than => 10.megabytes
  
end
