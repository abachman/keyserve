require 'dm-core'

if ENV['RACK_ENV'] == 'cucumber'
  # local machine - test
  puts "using cucumber database"
  DataMapper.setup(:default, {
    :database => 'keyserve_cuke',
    :adapter  => 'postgres',
    :user     => '',
    :password => ''
  })
else
  # local machine - dev and production
  DataMapper.setup(:default, ENV['DATABASE_URL'] || {
    :database => 'keyserve_dev',
    :adapter  => 'postgres',
    :user     => '',
    :password => ''
  })
end
