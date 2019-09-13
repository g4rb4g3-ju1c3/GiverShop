


class List < ActiveRecord::Base

   belongs_to :user

   has_many :items, dependent: :delete_all
#   has_many :products, through: :items
#   has_many :vendors, through: :items

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates "name",    presence: true, length: { minimum: 1 }
   validates "user_id", presence: true

private

   def strip_whitespace
      self.name  = self.name.strip  unless self.name.nil?
      self.notes = self.notes.strip unless self.notes.nil?
   end

   def blank_to_null
      self.notes = nil if self.notes.blank?
   end

end



