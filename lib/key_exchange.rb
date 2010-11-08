module KeyExchange
  # returns local copy of remote keyfile
  def get_remote_auth_file remote
    temp_auth = Tempfile.new('auth')

    # bring auth_key to local directory
    Net::SFTP.start(remote.hostname, remote.username, :auth_methods => ['publickey', 'password'], :password => remote.password) do |sftp|
      if (sftp.dir.entries(".").map {|f| f.name}).include?('.ssh')
        if (sftp.dir.entries(".ssh").map {|f| f.name}).include?('authorized_keys')
          sftp.download!(".ssh/authorized_keys", temp_auth.path)
        end
      else 
        sftp.mkdir!(".ssh")
      end
    end

    temp_auth
  end
end
