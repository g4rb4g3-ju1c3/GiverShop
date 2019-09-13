


class Inventory < ActiveRecord::Base

   belongs_to :vendor
   belongs_to :product

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates_uniqueness_of :product_id, scope: :vendor_id, message: "is already in the inventory"
   validates :price, allow_blank: true, numericality: true
#   validates :price, allow_blank: true, numericality: true, inclusion: { in: 0.01..999999.99 }

private

   def strip_whitespace
      self.location = self.location.strip unless self.location.nil?
      self.notes    = self.notes.strip    unless self.notes.nil?
   end

   def blank_to_null
      self.price    = nil if self.price.blank?
      self.location = nil if self.location.blank?
      self.notes    = nil if self.notes.blank?
   end

end



