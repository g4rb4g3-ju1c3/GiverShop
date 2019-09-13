


class User < ActiveRecord::Base

#   EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

   has_secure_password

   has_many :permission, dependent: :delete_all
   has_many :list,       dependent: :delete_all
   has_many :note,       dependent: :delete_all

   before_validation :strip_whitespace
   before_save       :blank_to_null

   validates :username,        presence: true, uniqueness: true, length: { minimum: 3 }
   validates :password,        presence: true,                   length: { minimum: 4 }, on: :update, allow_blank: true
#   validates :password_digest, presence: true
   validates :name,            length: { minimum: 1 }
#   validates :email,           format: EMAIL_REGEX

private

   def strip_whitespace
      self.username = self.username.strip  unless self.username.nil?
      self.settings = self.settings.strip  unless self.settings.nil?
      self.name     = self.name.strip      unless self.name.nil?
      self.phone    = self.phone.strip     unless self.phone.nil?
      self.email    = self.email.strip     unless self.email.nil?
      self.notes    = self.notes.strip     unless self.notes.nil?
   end

   def blank_to_null
      self.name     = nil if self.name.blank?
      self.settings = nil if self.settings.blank?
      self.phone    = nil if self.phone.blank?
      self.email    = nil if self.email.blank?
      self.notes    = nil if self.notes.blank?
   end

end



