class ServerUser < ActiveRecord::Base
  belongs_to :server
  belongs_to :user
  belongs_to :account
  belongs_to :ssh_key

  validates_uniqueness_of :user_id, :scope => [:server_id, :account_id]
end
