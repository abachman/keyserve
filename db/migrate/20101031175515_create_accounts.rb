class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string  :username
      t.text    :description
      t.integer :server_id
      t.integer :ssh_key_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
