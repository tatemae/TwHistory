# From:
# http://oldwiki.rubyonrails.org/rails/pages/HowtoExportDataAsCSV
# http://stackoverflow.com/questions/1939333/how-to-make-a-ruby-string-safe-for-a-filesystem
module CsvMethods

  protected

    # facilitates returning the CSV file from FasterCSV directly
    # to the browser for download
    def stream_csv(filename)
      filename = sanitize_filename(filename) + '.csv'
      #this is required if you want this to work with IE
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers['Pragma'] = 'public'
        headers["Content-type"] = "text/plain" 
        headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
        headers['Expires'] = "0" 
      else
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
      end

      csv_string = FasterCSV.generate do |csv|
        yield csv
      end
      send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', 
                            :filename => filename,
                            :disposition => "attachment") 

    end
    
    def sanitize_filename(filename)
      returning filename.strip do |name|
       # NOTE: File.basename doesn't work right with Windows paths on Unix
       # get only the filename, not the whole path
       name.gsub! /^.*(\\|\/)/, ''
       # Replace all non alphanumeric, underscore or periods with underscore
       name.gsub! /[^\w\.\-]/, '_'
       # Basically strip out the non-ascii alphabets too and replace with x. 
       # You don't want all _ :)
       name.gsub!(/[^0-9A-Za-z.\-]/, 'x')
      end
    end
end