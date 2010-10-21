source 'http://rubygems.org'

gem 'rails', '3.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

if RUBY_VERSION < '1.9'
  gem "ruby-debug"
end

gem "mysql"

# gem 'authlogic'
# TODO this is temporary until the official authlogic gem is updated for rails 3
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'

gem "will_paginate"
gem "bcrypt-ruby", ">=2.1.1", :require => "bcrypt"
gem "nested_set"
gem "sanitize"
gem "paperclip"
gem "friendly_id"
gem "hoptoad_notifier"
gem "recaptcha", :require => "recaptcha/rails"
gem "tiny_mce"
gem "acts-as-taggable-on"

gem "geokit"
gem "babelphish"
gem "uploader"
gem "muck-engine", ">=3.0.4"
gem "muck-users", ">=3.0.5"
gem "muck-solr", :require => "acts_as_solr"
gem "muck-raker"
gem "muck-comments", ">=3.0.2"
gem "muck-contents"
gem "muck-profiles"
gem "muck-activities"
gem "muck-friends"
gem "muck-shares"
gem "muck-invites"

#gem "muck-users", :path => "~/projects/muck-users"

group :test, :development do
  gem "rspec-rails", ">=2.0.1"
  gem "cucumber-rails"
end

group :test do
  gem "autotest"
  gem "capybara"
  gem "shoulda"
  gem "factory_girl"
  gem "cucumber"
  gem "rcov"
  gem "rspec", ">=2.0.1scr  "
  gem "database_cleaner"
  gem "spork"
  gem "launchy"
end
