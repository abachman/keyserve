class FileMissingError < RuntimeError; end

module Keyserve
  module SSH
    class Hosts
      KNOWN_HOSTS_PATH = "#{ENV['HOME']}/.ssh/known_hosts"

      def self.known_hosts
        File.readlines(KNOWN_HOSTS_PATH) if File.exists?(KNOWN_HOSTS_PATH)
      end

      def self.recognize_remote_host hostname
        kh = known_hosts
        if kh and kh.grep(/#{hostname}/).size == 0
          puts "Adding #{ hostname } to #{ KNOWN_HOSTS_PATH }"
          system "ssh-keyscan -t rsa,dsa #{ hostname } >> #{ KNOWN_HOSTS_PATH }"
          if $? == 0
            puts "Done"
          else
            puts "ERROR"
          end
        else
          if kh.nil?
            raise FileMissingError, "Could not find known_hosts file at #{ KNOWN_HOSTS_PATH }"
          else
            puts "#{hostname} is already a known host"
          end
        end
      end
    end
  end
end
