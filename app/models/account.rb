class Account < ActiveRecord::Base
  belongs_to :server
  has_many :server_users
  has_many :users, :through => :server_users
end
