


class ApplicationController < ActionController::Base

   # Prevent CSRF attacks by raising an exception.
   # For APIs, you may want to use :null_session instead.
   protect_from_forgery with: :exception



   def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end
   helper_method :current_user

   def current_user_id
      return session[:user_id]
   end
   helper_method :current_user_id



   def auth_login
      redirect_to root_path unless session[:user_id]
   end

   def auth_permission(auth_object, type)
      if !auth_object.nil? && !auth_object.permissions.nil? && !type.nil?
         return auth_object.permissions.to_s.include?("|" + type + "|")
      else
         return false
      end
   end
   helper_method :auth_permission

   def auth_attribute(attribute)
      if !attribute.nil?
         return current_user.settings.include?("|" + attribute + "|")
      else
         return false
      end
   end
   helper_method :auth_attribute

   def auth_su
      return current_user.settings.include?("|su|")
   end
   helper_method :auth_su



   def get_setting(setting)
      if !setting.nil?
         return session[setting]
      end
   end
   helper_method :get_setting

   def set_setting(setting, value)
      if !setting.nil?
         session[setting] = value
      end
   end
   helper_method :set_setting

end



