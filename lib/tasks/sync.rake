namespace :keys do
  desc "Sync remote keys into the local database."
  task :sync => :environment do
    Server.all.each do |server| 
      puts "synchronizing #{server.name} down"
      server.synchronize_remote_keys!
    end
  end
end
