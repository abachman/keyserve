require "rubygems"
require 'bundler'
Bundler.setup

task :environment do
  require 'app'
end

desc 'Load the seed data from db/seeds.rb'
task :seed => :environment do
  seed_file = File.join(KeyserveApp.root, 'db', 'seeds.rb')
  load(seed_file) if File.exist?(seed_file)
end

namespace :dm do
  require 'config/database'

  namespace :auto do
    desc "Perform automigration (reset your db data)"
    task :migrate => :environment do
      ::DataMapper.auto_migrate!
      puts "<= dm:auto:migrate executed"
    end

    desc "Perform non destructive automigration"
    task :upgrade => :environment do
      ::DataMapper.auto_upgrade!
      puts "<= dm:auto:upgrade executed"
    end
  end

  namespace :migrate do
    task :load => :environment do
      require 'dm-migrations/migration_runner'
      FileList["db/migrate/*.rb"].each do |migration|
        load migration
      end
    end

    desc "Migrate up using migrations"
    task :up, :version, :needs => :load do |t, args|
      version = args[:version] || ENV['VERSION']
      migrate_up!(version)
      puts "<= dm:migrate:up #{version} executed"
    end

    desc "Migrate down using migrations"
    task :down, :version, :needs => :load do |t, args|
      version = args[:version] || ENV['VERSION']
      migrate_down!(version)
      puts "<= dm:migrate:down #{version} executed"
    end
  end

  desc "Migrate the database to the latest version"
  task :migrate => 'dm:migrate:up'

  desc "Create the database"
  task :create => :environment do
    config = DataMapper.repository.adapter.options.symbolize_keys
    user, password, host = config[:user], config[:password], config[:host]
    database       = config[:database]  || config[:path].sub(/\//, "")
    charset        = config[:charset]   || ENV['CHARSET']   || 'utf8'
    collation      = config[:collation] || ENV['COLLATION'] || 'utf8_unicode_ci'
    puts "=> Creating database '#{database}'"
    system("createdb", "-E", charset, "-U", user, database)
    puts "<= dm:create executed"
  end

  desc "Drop the database (postgres and mysql only)"
  task :drop => :environment do
    config = DataMapper.repository.adapter.options.symbolize_keys
    user, password, host = config[:user], config[:password], config[:host]
    database = config[:database] || config[:path].sub(/\//, "")
    puts "=> Dropping database '#{database}'"
    system("dropdb", "-U", user, database)
    puts "<= dm:drop executed"
  end

  desc "Drop the database, migrate from scratch and initialize with the seed data"
  task :reset => [:drop, :setup]

  desc "Create the database migrate and initialize with the seed data"
  task :setup => [:create, 'auto:migrate', :seed]
end

