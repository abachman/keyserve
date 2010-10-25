class User
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :email,      String
  property :created_at, DateTime
end

class Key
  include DataMapper::Resource

  property :id,         Serial
  property :user_id,    Integer
  property :name,       String
  property :contents,   Text
  property :created_at, DateTime
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

  property :server_id, Integer
  property :user_id,   Integer
end

