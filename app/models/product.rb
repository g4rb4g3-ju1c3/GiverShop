


class Product < ActiveRecord::Base

   has_many :items #,       dependent: :delete_all
   has_many :inventories, dependent: :delete_all
   has_many :vendors,     through: :inventories

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates :description, presence: true, length: { minimum: 1 }, uniqueness: true

private

   def strip_whitespace
      self.description = self.description.strip unless self.description.nil?
      self.size        = self.size.strip        unless self.size.nil?
      self.origin      = self.origin.strip      unless self.origin.nil?
      self.notes       = self.notes.strip       unless self.notes.nil?
   end

   def blank_to_null
      self.size   = nil if self.size.blank?
      self.origin = nil if self.origin.blank?
      self.notes  = nil if self.notes.blank?
   end

end



