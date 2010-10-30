namespace :twhistory do
    
  desc 'Broadcast scheduled events that are ready to go.'
  task :broadcast => :environment do
    puts "Started broadcast. This make take a few minutes...."
    ScheduledItem.broadcast_scheduled_items
    puts "Finished broadcast."
  end

end
