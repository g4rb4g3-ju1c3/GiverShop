


class Item < ActiveRecord::Base

   belongs_to :list
   belongs_to :product
   has_many   :vendors, through: :product

   before_validation :strip_whitespace
   before_save       :blank_to_null

#   validates_uniqueness_of :product_id, scope: :list_id, message: "is already in the list"
   validates :product_id, uniqueness: true, allow_nil: true
   validates :priority,   numericality: true, :inclusion => 0..100
   validates :quantity,   numericality: true, :inclusion => 1..9999, allow_blank: true
#   validates_inclusion_of :quantity, in: 1..9999, message: "out of range"

private

   def strip_whitespace
      self.notes = self.notes.strip unless self.notes.nil?
   end

   def blank_to_null
      self.quantity = nil if self.quantity.blank?
      self.notes    = nil if self.notes.blank?
   end

end



