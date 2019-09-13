


class Group < ActiveRecord::Base

   has_many :list
   has_many :note

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates :name,    presence: true, length: { minimum: 1 }
   validates :user_id, presence: true
   validates :admins,  presence: true

private

   def strip_whitespace
      self.name        = self.name.strip        unless self.name.nil?
      self.admins      = self.admins.strip      unless self.admins.nil?
      self.users       = self.users.strip       unless self.users.nil?
      self.settings    = self.settings.strip    unless self.settings.nil?
      self.description = self.description.strip unless self.description.nil?
      self.lists       = self.lists.strip       unless self.lists.nil?
      self.notes       = self.notes.strip       unless self.notes.nil?
   end

   def blank_to_null
      self.users       = nil if self.users.blank?
      self.settings    = nil if self.settings.blank?
      self.description = nil if self.description.blank?
      self.lists       = nil if self.lists.blank?
      self.notes       = nil if self.notes.blank?
   end

end



