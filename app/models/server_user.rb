# a join class connecting a keyserve user with their primary key to a remote server
class ServerUser < ActiveRecord::Base
  belongs_to :server
  belongs_to :user
  belongs_to :account

  validates_uniqueness_of :user_id, :scope => [:server_id, :account_id]

  def public_key
    user.ssh_keys.first.public_key
  end

  def sign_in
    SignIn.new(
      :hostname => server.hostname,
      :username => account.username,
      :public_key => user.ssh_keys.first.public_key
    )
  end
end
