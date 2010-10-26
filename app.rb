# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for its own reasons.

# libraries
require 'sinatra/base'
require 'sinatra_warden'
require 'json'
require 'haml'
require 'sass'

# local
require 'config/database'
require 'models'
require 'lib/keyserve'

Warden::Strategies.add(:password) do
  def valid?
    params['email'] && params['password']
  end

  def authenticate!
    u = User.authenticate(params['email'], params['password'])
    u.nil? ? fail!("Could not log you in.") : success!(u)
  end
end

class KeyserveApp < Sinatra::Base
  register Sinatra::Warden
  set :auth_failure_path, '/login'

  set :haml, {:format => :html5 }
  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }

  configure :production do
    # Configure stuff here you'll want to
    # only be run at Heroku at boot

    # TIP:  You can get you database information
    #       from ENV['DATABASE_URI'] (see /env route below)
  end

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.serialize_into_session { |user| user.id }
    manager.serialize_from_session { |id| User.get(id) }
    manager.failure_app = KeyserveApp
  end

  helpers do
    include Keyserve::SSH::Helpers
    include Keyserve::Helpers

    include Rack::Utils
    alias_method :h, :escape_html

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
    authorize!

    haml :index, :layout => :'layouts/default'
  end

  get '/list' do
    authorize!('/fail')

    content_type :json
    Key.all.map(&:name).to_json
  end

  not_found do
    content_type :json
    {:error => "not found"}.to_json
  end

  get '/fail' do
    content_type :json
    {:error => "not authorized"}.to_json
  end

  get '/key/:keyname' do
    authorize!('/fail')

    content_type 'text/plain'
    if keys[params[:keyname]]
      keys[params[:keyname]] + "\n"
    else
      halt 403, {'Content-Type' => 'text/plain'}, "could not find entry\n"
    end
  end

  get '/add' do
    authorize!

    haml :add, :layout => :'layouts/default'
  end

  post '/add' do
    authorize!

    haml "%h1 GOT YOUR INPUT\n\n%pre\n  #{params.inspect}"
  end

  get '/remote' do
    authorize!

    haml :remote, :layout => :'layouts/default'
  end

  post '/remote' do
    authorize!

    haml "%p BARF OUT: #{ params[:hostname] }\n%ul\n  %li #{ Keyserve::SSH::Hosts.known_hosts.map{|k| k}.join("\n  %li ") }"
  end
end

