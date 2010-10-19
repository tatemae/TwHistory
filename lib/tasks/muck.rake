require 'fileutils'

namespace :muck do
    
  desc 'Translate app'
  task :translate => :environment do
    puts 'translating'
    system("babelphish -o -y /Users/jbasdf/projects/twhistory/config/locales/en.yml")
  end

end
