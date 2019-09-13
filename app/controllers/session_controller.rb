


class SessionController < ApplicationController

#   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   @@anger_intensity = 0

   def new
      @@anger_intensity = 0
      render layout: "login"
   end

   def create
      respond_to do |format|
         format.js {
            user = User.find_by_username(params[:username])
            if user && user.authenticate(params[:password])
               session[:user_id] = user.id
               @@anger_intensity = 0
               render js: "window.location.href = '" + user_path(user.id) + "';"
            else
               session[:user_id] = nil
               @@anger_intensity += 1
               render js: "set_anger_level(" + @@anger_intensity.to_s + ");"
            end
         }
      end
   end

   def destroy
      respond_to do |format|
         session[:user_id] = nil
         format.html { redirect_to root_path }
         format.js   { render js: "window.location.href = '" + root_path + "';" }
      end
   end

end



