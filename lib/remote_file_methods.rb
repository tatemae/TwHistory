# Adapted from http://trevorturk.com/2008/12/11/easy-upload-via-url-with-paperclip/
require 'open-uri'
module RemoteFileMethods
  extend ActiveSupport::Concern
  included do
    attr_accessor :photo_url
    before_validation :download_remote_photo, :if => :photo_url_provided?
    validates_presence_of :photo_remote_url, :if => :photo_url_provided?, :message => I18n.translate('general.url_not_found_error')
  end
  
  private

    def photo_url_provided?
      !self.photo_url.blank?
    end
  
    def download_remote_photo
      begin
        io = open(URI.parse(photo_url).to_s)
        def io.original_filename; base_uri.path.split('/').last; end
        self.photo = io.original_filename.blank? ? nil : io
        self.photo_remote_url = photo_url
      rescue => ex
        debugger
        t = 0
      end
    end
  
end