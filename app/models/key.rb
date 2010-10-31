class Key < ActiveRecord::Base
  belongs_to :user

  validate do |key|
    key.must_be_valid
  end

  def must_be_valid
    type, key_string, _name = self.contents.split
    if  (type.nil? || type.empty?) || 
        (key_string.nil? || key_string.empty?) || 
        (_name.nil? || _name.empty?)
      errors.add_to_base "This doesn't appear to be a valid key"
    end
  end

  before_create :set_name_from_contents
  def set_name_from_contents
    type, key_string, _name = self.contents.split
    if !((type.nil? || type.empty?) || 
         (key_string.nil? || key_string.empty?) || 
         (_name.nil? || _name.empty?))
      self.name = _name
    end
  end

end
