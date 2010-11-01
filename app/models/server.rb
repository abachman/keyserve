class Server < ActiveRecord::Base
  has_many :accounts
  has_many :server_users
  has_many :users, :through => :server_users
end
