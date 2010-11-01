class Server < ActiveRecord::Base
  has_many :accounts
  has_many :server_users
  has_many :users, :through => :server_users
  has_many :ssh_keys, :through => :server_users

  def self.for_select
    order(:hostname).map {|k| [k.hostname, k.id]}
  end
end
