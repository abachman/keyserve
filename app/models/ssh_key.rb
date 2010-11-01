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
end
