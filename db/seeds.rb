# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# users
admin_user = User.create :email => 'admin@slsdev.net', :password => 'password', :password_confirmation => 'password'
admin_user.admin = true; admin_user.save
User.create :email => 'user@slsdev.net', :password => 'password', :password_confirmation => 'password'

# default key
default_key = SshKey.create(
  :public_key => File.read(File.join(Rails.root, 'test/fixtures/id_rsa.pub'))
)

# server
server = Server.create :name => 'staging', :hostname => '12.167.155.8'
server.accounts.create :username => 'deploy', :ssh_key => default_key

