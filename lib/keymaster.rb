require 'tempfile'
require 'net/ssh'
require 'net/sftp'
require 'key_exchange'

class Keymaster
  include KeyExchange
  include Singleton
  
  # return list of public keys associated with given server (username@hostname)
  def parse_remote_keys server
    get_remote_auth_file(server).readlines.map {|k| k.chomp}
  end

  def set_remote_keys! server, keys

  end
    
private
  # used to pass public keys between remote hosts and add them to keyfiles, 
  #
  # If server A's public key is added to server B's authorized_keys file, 
  # server A can login to server B without a password.
  #
  # key: string containing public key
  # remote: server with properties 'hostname', 'username', 'password'
  def apply_key_to_remote key, remote, source=nil
    authorized_keys = get_remote_auth_file(remote)

    # add key if it hasn't already been added (to local copy of authorized_keys)
    if !authorized_keys.readlines.grep(/#{key}/)
      authorized_keys.write("\n" + key + "\n")
      authorized_keys.close

      Net::SFTP.start(remote.hostname, 
                      remote.username, 
                      :auth_methods => ['publickey', 'password'], 
                      :password => remote.password) do |sftp|
        sftp.upload!(authorized_keys.path, '.ssh/authorized_keys')
      end
    else
      puts "#{ source }'s key already exists on #{ remote.id }"
    end
  end
end
