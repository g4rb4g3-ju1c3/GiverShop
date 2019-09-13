


class Vendor < ActiveRecord::Base

   has_many :inventories, dependent: :delete_all
   has_many :products,    through: :inventories

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates :name, presence: true, length: { minimum: 1 }, uniqueness: true

private

   def strip_whitespace
      self.name  = self.name.strip    unless self.name.nil?
      self.notes = self.notes.strip   unless self.notes.nil?
   end

   def blank_to_null
      self.notes = nil if self.notes.blank?
   end

end



