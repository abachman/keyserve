require 'keymaster'

# a username on a remote server
class Account < ActiveRecord::Base
  belongs_to :server
  belongs_to :ssh_key # default login key
  # has_one :default_user, :through => :ssh_key, :foreign_key => :user_id, :class_name => "User"
  has_many :server_users
  has_many :users, :through => :server_users

  validates_uniqueness_of :username, :scope => :server_id

  def sign_in
    SignIn.new(
      :username => username, 
      :hostname => server.hostname, 
      :public_key => ssh_key.public_key
    )
  end

  def remote_keys
    Keymaster.instance.parse_remote_keys account.sign_in
  end

  def set_remote_keys!
    Keymaster.instance.set_remote_keys account.sign_in, ssh_keys.map(&:public_key)
  end
end
