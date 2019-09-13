


class Note < ActiveRecord::Base

   belongs_to :user

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates "title",   presence: true, length: { minimum: 1 }
   validates "user_id", presence: true

private

   def strip_whitespace
      self.title       = self.title.strip        unless self.title.nil?
      self.admins      = self.admins.strip       unless self.admins.nil?
      self.users       = self.users.strip        unless self.users.nil?
      self.description = self.description.strip  unless self.description.nil?
   end

   def blank_to_null
      self.admins      = nil if self.admins.blank?
      self.users       = nil if self.users.blank?
      self.description = nil if self.description.blank?
      self.content     = nil if self.content.blank?
   end

end



