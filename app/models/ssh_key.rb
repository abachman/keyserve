class SshKey < ActiveRecord::Base
  belongs_to :user

  validates_format_of     :public_key, :with => %r{^ssh-(rsa|dss)\b}
  validates_presence_of   :public_key
  validates_uniqueness_of :public_key

  def name
    @name ||= begin
      type, key_string, _name = self.public_key.split
      _name
    end
  end

  def self.for_select
    order(:public_key).map {|k| [k.name, k.id]}
  end

  def self.unclaimed
    where(:user_id => nil)
  end
end
