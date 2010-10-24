SOLR_CONFIG_PATH = "#{::Rails.root}/config/solr"
SOLR_LOGS_PATH = "#{::Rails.root}/log"
SOLR_PIDS_PATH = "#{::Rails.root}/tmp/pids/solr"

if ::Rails.env.production?
  SOLR_DATA_PATH = "#{::Rails.root}/../../shared/solr_indexes"
else
  SOLR_DATA_PATH = "#{::Rails.root}/solr_indexes"
end
