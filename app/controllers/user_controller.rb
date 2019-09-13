


class UserController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
      respond_to do |format|
         if auth_su
            @users = User.select("*, id AS datalist_item_id, '' AS existing_item_id, username AS text, NULL AS subtext")
                         .order("name ASC")
            @datalist = @users
            format.html { render "index" }
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def show
      respond_to do |format|
         if auth_su || (current_user_id.to_s == params[:id])
            @user = User.find(params[:id])
            format.html { render "show" }
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def new
      respond_to do |format|
         if auth_su
            @user = User.new
            if !params[:username].blank?
               @user.username = params[:username]
            end
            format.html { render "new" }
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def edit
      respond_to do |format|
         if auth_su
            @user = User.find(params[:id])
            format.html { render "edit" }
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def create
      respond_to do |format|
         if !params[:add_text].nil?
            format.js { render js: "window.location.href = '" + new_user_path + "?username=' + encodeURIComponent('" + params[:add_text] + "');" }
         else
            user = User.new(user_params)
            if user.save
               format.js { render js: "content.callback('" + action_name + "', '" + user.id.to_s + "');" }
            else
               @error_object = user
               format.js { render partial: "shared/errors" }
            end
         end
      end
   end

   def update
      respond_to do |format|
         user = User.find(params[:id])
         if user.update(user_params)
            format.js { render js: "content.callback('" + action_name + "', '" + user.id.to_s + "');" }
         else
            @error_object = user
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update_settings
      respond_to do |format|
         user     = User.find(current_user_id)
         if params[:email] == "true"
            UserMailer.welcome_email(user).deliver_later
         end
         settings = Hash.new(user.settings)
         settings["show_advanced"] = params["show_advanced"]
         user.settings = settings.to_s
         if user.save
            session["show_advanced"] = params["show_advanced"]
            format.js { render js: "content.callback('" + action_name + "', '" + user.id.to_s + "');" }
         else
            @error_object = user
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def destroy
      respond_to do |format|
         user = User.find(params[:id])
         if user.destroy
            format.js { render js: "content.callback('" + action_name + "', '" + user.id.to_s + "');" }
         else
            @error_object = user
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :settings, :name, :phone, :email, :image_id, :notes)
   end

   def user_params_without_password
      params.require(:user).permit(:username, :password, :password_confirmation, :settings, :name, :phone, :email, :image_id, :notes)
   end

end



