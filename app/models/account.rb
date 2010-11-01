class Account < ActiveRecord::Base
  belongs_to :server
  has_many :server_users
  has_many :users, :through => :server_users

  def self.not_for_user user
    accounts_subset = "SELECT server_users.account_id FROM server_users WHERE server_users.user_id = ?"
    where(["NOT id in (#{ accounts_subset })", user.id]) 
  end
end
