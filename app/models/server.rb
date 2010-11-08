class Server < ActiveRecord::Base
  # in case it's needed to log in
  attr_accessor :password

  has_many :accounts
  has_many :server_users
  has_many :users, :through => :server_users
  has_many :ssh_keys, :through => :server_users

  def self.for_select
    order(:hostname).map {|k| [k.hostname, k.id]}
  end

  # bring all remote keys into local storage, create anonymous SshKey for every
  # key not already known to the service
  def synchronize_remote_keys!
    accounts.each do |account|
      begin
        account.remote_keys.each do |key|
          # store of find local key
          ssh_key = SshKey.find_by_public_key(key)
          if ssh_key.nil?
            ssh_key = SshKey.new(:public_key => key)
            if ssh_key.save
              Rails.logger.info "Added public key: #{ ssh_key.name }"
            else
              Rails.logger.error "Failed to add public key: " +
                                 "#{ ssh_key.errors.full_messages.join(", ") }"
              raise "Failed to add public key"
            end
          else
            # if this is a newly synced or the key is in the system but
            # unclaimed, user will be nil
            user = ssh_key.user

            # create server users
            if !(user.nil? || 
                 ServerUser.exists?(:server_id => self.id, 
                                    :account_id => account.id, 
                                    :user_id => user.id))
              ServerUser.create :server => self, :account => account, :user => user
            end
          end
        end
      rescue Exception => ex
        Rails.logger.error "Failed to retrieve remote keys: #{ ex.message }"
      end
    end
  end
end
