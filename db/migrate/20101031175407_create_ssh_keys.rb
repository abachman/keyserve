class CreateSshKeys < ActiveRecord::Migration
  def self.up
    create_table :ssh_keys do |t|
      t.text :public_key
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :keys
  end
end
