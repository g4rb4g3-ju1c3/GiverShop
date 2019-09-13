


class Comment < ActiveRecord::Base

   has_many :user

   before_validation :strip_whitespace

   validates :user_id,     presence: true
   validates :object_id,   presence: true
   validates :object_type, presence: true
   validates :content,     presence: true, length: { minimum: 1 }

private

   def strip_whitespace
#      self.object_type = self.object_type.strip unless self.object_type.nil?
      self.content     = self.content.strip     unless self.content.nil?
   end

end



