ENV['RAILS_ENV'] ||= MuckRaker.configuration.rails_env  
SOLR_CONFIG_PATH = "#{RAILS_ROOT}/config/solr"
SOLR_LOGS_PATH = "#{RAILS_ROOT}/log"
SOLR_PIDS_PATH = "#{RAILS_ROOT}/tmp/pids/solr"

RAKER_LOGS_PATH = "#{RAILS_ROOT}/log"
RAKER_PIDS_PATH = "#{RAILS_ROOT}/tmp/pids/raker"

if ENV['RAILS_ENV'] == "production"
  SOLR_DATA_PATH = "#{RAILS_ROOT}/../../shared/solr_indexes"
else
  SOLR_DATA_PATH = "#{RAILS_ROOT}/solr_indexes"
end
