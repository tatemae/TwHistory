# rm -rf ~/.bundle/ ~/.gem/; rm -rf $GEM_HOME/bundler/ $GEM_HOME/cache/bundler/; rm -rf .bundle/; rm -rf vendor/cache/; rm -rf Gemfile.lock
source 'http://rubygems.org'

gem 'rails', '3.0.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

if RUBY_VERSION < '1.9'
  gem "ruby-debug"
end

gem "mysql"
gem "rack", ">=1.2.2"

# gem 'authlogic'
# TODO this is temporary until the official authlogic gem is updated for rails 3
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'

gem "will_paginate", "~> 3.0.0"
gem "bcrypt-ruby", ">=2.1.1", :require => "bcrypt"
gem "nested_set"
gem "sanitize"
gem "paperclip", "~>2.4.5"
gem "friendly_id", "3.1.7"
gem "hoptoad_notifier"
gem 'newrelic_rpm'
gem "recaptcha", :require => "recaptcha/rails"
gem "tiny_mce"
gem "acts-as-taggable-on"
gem "fastercsv"
gem "omniauth", "~>1.1.1"
gem 'omniauth-twitter'
gem "geokit"
gem "delayed_job", "2.1.1"
gem "twitter", "~>4.4.2"
gem 'sunspot_rails'
gem "jammit"

gem "babelphish"
gem "uploader"
gem "muck-engine", "~>3.4.0"
gem "muck-users"
#gem "muck-solr", :require => "acts_as_solr"
gem "muck-comments"
gem "muck-contents"
gem "muck-profiles"
gem "muck-activities"
gem "muck-friends"
gem "muck-shares"
gem "muck-invites", ">=3.4.0"
#gem "muck-resources"
gem "muck-portablecontacts"

#gem "muck-solr", :require => "acts_as_solr", :path => "~/projects/acts_as_solr"
#gem "muck-engine", :path => "~/projects/muck-engine"
#gem "muck-users", :path => "~/projects/muck-users"
#gem "muck-contents", :path => "~/projects/muck-contents"

group :test, :development do
  gem "rspec-rails"
  gem 'sunspot_solr'
end

group :test do
  gem "spork", "~> 0.9.0.rc2"
  gem 'growl'
  gem 'guard-rspec'
  gem "factory_girl", "~>2.6.4"
  gem "shoulda"
  gem "rcov"
  gem "rspec"
  gem "database_cleaner"
  gem "launchy", "~>0.3.5"
  gem "capybara"
  gem "fakeweb"
end
