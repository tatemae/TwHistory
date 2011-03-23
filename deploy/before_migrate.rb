run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/"
run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/"
run "ln -nfs #{shared_path}/cache/ #{release_path}/tmp/"