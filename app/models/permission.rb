


class Permission < ActiveRecord::Base

   belongs_to :user

   before_validation :strip_whitespace

private

   def strip_whitespace
      self.permissions = self.permissions.strip unless self.permissions.nil?
   end

end



