class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :ssh_keys
  has_many :server_users
  has_many :servers, :through => :server_users
  has_many :accounts, :through => :server_users

  def self.by_email
    order('email')
  end

  def self.for_select
    by_email.map {|u| [u.email, u.id]}
  end
end
