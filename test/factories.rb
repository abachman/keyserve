# This will guess the User class
Factory.define :user do |u|
  u.email                 'user@slsdev.net'
  u.password              'password'
  u.password_confirmation 'password'
  u.admin                 false
end

# This will use the User class (Admin would have been guessed)
Factory.define :admin, :parent => :user do |u|
  u.admin true
end

Factory.define :server do |f|
  f.name "my server"
  f.hostname "127.0.0.1"
end
