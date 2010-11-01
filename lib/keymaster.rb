require 'tempfile'
require 'net/ssh'
require 'net/sftp'

class Keymaster

end

module KeyExchange

  # used to pass public keys between remote hosts and add them to keyfiles, 
  #
  # If server A's public key is added to server B's authorized_keys file, 
  # server A can login to server B without a password.
  #
  # remote has keys: 'hostname', 'username', 'password'
  def _apply_key_to_remote key, remote, source=nil
    temp_auth = Tempfile.new('auth')

    # bring auth_key to local directory
    Net::SFTP.start(remote['hostname'], remote['username'], :auth_methods => ['publickey', 'password'], :password => remote['password'] ) do |sftp|
      if (sftp.dir.entries(".").map {|f| f.name}).include?('.ssh')
        if (sftp.dir.entries(".ssh").map {|f| f.name}).include?('authorized_keys')
          sftp.download!(".ssh/authorized_keys", temp_auth.path)
        end
      else 
        sftp.mkdir!(".ssh")
      end
    end

    # add key if it hasn't already been added (to local copy of authorized_keys)
    unless temp_auth.read.include? key
      puts "#{ source }'s key doesn't exist on #{ remote['id'] }, adding..."
      temp_auth.write("\n" + key + "\n")
      temp_auth.close

      Net::SFTP.start(remote['hostname'], remote['username'], :auth_methods => ['publickey', 'password'], :password => remote['password']) do |sftp|
        sftp.upload!(temp_auth.path, '.ssh/authorized_keys')
      end
    else
      puts "#{ source }'s key already exists on #{ remote['id'] }"
    end
  end
end
