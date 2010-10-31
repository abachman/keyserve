class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.text :description
      t.integer :server_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
