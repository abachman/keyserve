require 'bcrypt'

class User
  include DataMapper::Resource
  include BCrypt

  property :id,            Serial
  property :name,          String, :length => 64
  property :email,         String, :length => 256
  property :created_at,    DateTime
  property :password_hash, String, :length => 1024

  ## Warden
  def self.authenticate(email, password)
    u = self.first(:email => email)
    u && (u.password == password ? u : nil)
  end

  ## Password related
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end

class Key
  include DataMapper::Resource

  property :id,         Serial
  property :user_id,    Integer
  property :name,       String
  property :contents,   Text
  property :created_at, DateTime
  property :token,      String
end

class Server
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :hostname,   String
  property :ip_address, String
end

class ServerUser
  include DataMapper::Resource

  property :id,         Serial
  property :server_id, Integer
  property :user_id,   Integer
end

