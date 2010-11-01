class ServerUser < ActiveRecord::Base
  belongs_to :server
  belongs_to :user
  belongs_to :account
  belongs_to :key
end
