# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for its own reasons.

require 'sinatra/base'
require 'config/database'
require 'json'
require 'haml'
require 'sass'

require 'lib/keyserve'

class KeyserveApp < Sinatra::Base
  set :session, true
  set :haml, {:format => :html5 }
  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }

  configure :production do
    # Configure stuff here you'll want to
    # only be run at Heroku at boot

    # TIP:  You can get you database information
    #       from ENV['DATABASE_URI'] (see /env route below)
  end

  helpers do
    def keys
      SshKeys::KEYS
    end

    ## Links
    def link_to text, url=nil
      haml "%a{:href => '#{ url || text }'} #{ text }"
    end

    def link_to_unless_current text, url=nil
      if url == request.path_info
        text
      else
        link_to text, url
      end
    end

    ## Resources
    def javascript_includes
      haml %{
      %link{:rel => 'stylesheet', :href => "/css/reset.css"}
      %link{:rel => 'stylesheet', :href => "/css/960.css"}
      %link{:rel => 'stylesheet', :href => "/css/text.css"}
      %link{:rel => 'stylesheet', :href => "/style.css"}
      }.gsub(/^ */,'')
    end

    def stylesheet_includes
      haml %{
      %script{:src => '/javascripts/jquery.js', :type => 'text/javascript'}
      %script{:src => '/javascripts/underscore.js', :type => 'text/javascript'}
      %script{:src => '/javascripts/backbone.js', :type => 'text/javascript'}
      }.gsub(/^ */,'')
    end
  end

  # SASS stylesheet
  get '/style.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end

  get '/' do
    haml :index, :layout => :'layouts/default'
  end

  get '/list' do
    content_type :json
    keys.keys.to_json
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
    haml :add, :layout => :'layouts/default'
  end

  post '/add' do
    haml "%h1 GOT YOUR INPUT\n\n%pre\n  #{params.inspect}"
  end

  get '/remote' do
    haml :remote, :layout => :'layouts/default'
  end

  post '/remote' do
    haml "%p BARF OUT: #{ params[:hostname] }\n%ul\n  %li #{ SshUtils.known_hosts.map{|k| k}.join("\n  %li ") }"
  end
end

