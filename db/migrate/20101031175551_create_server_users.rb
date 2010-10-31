class CreateServerUsers < ActiveRecord::Migration
  def self.up
    create_table :server_users do |t|
      t.integer :user_id
      t.integer :server_id

      t.timestamps
    end
  end

  def self.down
    drop_table :server_users
  end
end
