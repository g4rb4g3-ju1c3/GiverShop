


class UserMailer < ApplicationMailer

   default from: "dontfuckinreply@givershop.com"

   def welcome_email(user)
      @user = user
      @url  = "https://escm.port0.org/givershop"
      mail(to: @user.email, subject: "Welcome to Give'rShop")
   end

end



