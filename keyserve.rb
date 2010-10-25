# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for its own reasons.

require 'rubygems'
require 'sinatra'
require 'json'
require 'haml'

require 'lib/keyserve'

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

def keys
  {
    'adam@vostro410'   => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8jUYhBn0gYUl0H/lDut/rniubDzEZjB9cGcs1SjdFfmoZsKUmGcF1spqhdhBwRVqr8Z/tCHGycOtfrDUoEpRc0YIsFNRTL9koEIS21cJbpSO1ewjVfnxsPeoEB7fr1GQFX5u3BFusgL07zTaMSSOycmKntmt+odHsylJrdriLstHSqPIUYckoYUmqFbAVq9jjNEvWmGLTvecM1cyr6dHKgImtvA07Mc6XhjYaUmNuEXM5knVlnHaTrk9rZ+EGTjj81LF+LFQevxiZd6wD50DEbMmWvAGHVlCTsuL5sM4cWqINBW1Cq1kYbikaPFM5VCHYCc2YOdg3z7UnOyRHMk5+Q== adam@vostro410",
    'adam@watermelon'  => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsHv2f+PEMnRDBq9MSqAsbbCgzgTeNEe6ys7MVaksnIodfgZAWmrY9owpzmD57z1iEZF+kpQ/7m2bBijF3A92X8QJmnlts5Zde/S8ifgT+IyvkQYZC+X/BR/YhBKTun9oDUEXbV03eUpGagVw7FleNUjfHE93beULcpXcwrhEOU2QksySMnhDtRIPxSWsv0iR1SFZDHwwPYmfh4V8W8VkQTLN/SBmR0qEhqEG+2Fr9LvQDpHQGzohjyKmvQLiA8fvx4wN+yiR2JJQqkhIa6gu4UkgaHWzvn7hWynAB1vg093DaoTMxwKGpkuhlpPvrOTHJfKb3jrGKGovnrc9utfVow== adam@watermelon",
    'adam@vostro410.2' => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0VaKlIuWQu6/twvH0iHa55oZE+09TVuXgaVuyKxrlvREyVGYOJKsjkOiuz6rHehbK1vAbZRbyyt/6F0dzr3BY1RbHzK/kNWT4IUG9whDKMxQPAyq9nkOdqJn5QqTT+1rrzKxNa2hgShFaIcT1KjSH/janLbDev7ZRD1/gUIUFC/ERo+39TRJ6uG4Q/dpQosJeLR8f0zwueroyG4/Iw2KChnjC/rbkdiDmEPk6INve1y43R+ca8b6pfFJ680437uG6Y7N1c3mnkjo+r0YDWOIqtnGxoRj+kgMCtJXe4h7hYfjHn1sQ/T5N4cyn+BSF08bqYfMR8CoyAm5xZxOalzXSQ== adam@vostro410",
    'rsa-key-20100223' => "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAvrs7GPrO+ZG4r3HUhJEUOC/aufouIMG2IQBnbVW9HxuOtqlagHjQKPX+Bj51U0MbSHABNu4hkfB9Vsq6Btvzjdim7xXlg7lp4smBx2fnI4baMgpJOIcFDsXb4mK+RfJ+OyPpfZaxf3a2qQnPNFJbk0irmzOQ4gDqCavlAvRv61s= rsa-key-20100223"
  }
end

get '/' do
  content_type :json
  keys.to_json
end

get '/list' do
  content_type :json
  keys.keys.to_json + "\n"
end

not_found do
  content_type :json
  {:error => "not found \n"}.to_json
end

get '/key/:keyname' do
  content_type 'text/plain'
  if keys[params[:keyname]]
    keys[params[:keyname]] + "\n"
  else
    halt 403, {'Content-Type' => 'text/plain'}, "could not find entry\n"
  end
end

get '/add' do
  haml :add
end

post '/add' do
  haml "%h1 GOT YOUR INPUT\n\n%pre\n  #{params.inspect}"
end

get '/remote' do
  haml "%p check remote: <form action='/remote/add' method='post'><input name='hostname' type='text' /></form>"
end

post '/remote/add' do
  haml "%p BARF OUT: #{ params[:hostname] }\n%ul\n  %li #{ SshUtils.known_hosts.map{|k| k}.join("\n  %li ") }"
end

__END__

@@ add
%h3 Add your public key

%form{:action => 'add', :method => 'POST'}
  %label
    id
    %input{:type => 'text', :name => 'key[id]'}
  %br
  %label
    key
    %input{:type => 'text', :name => 'key[value]', :size => 80}
  %br
  %input{:type => 'submit'}

