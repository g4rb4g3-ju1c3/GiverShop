


class GroupController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
      @notes = Permission.select("permissions, groups.*, " +
                                 "groups.id AS datalist_list_row_id, NULL AS datalist_object_id, groups.name AS datalist_text, NULL AS datalist_subtext")
                         .joins("LEFT JOIN groups ON groups.id = object_id")
                         .where("user_id = ? AND object_type = 3", current_user_id)
                         .order("name ASC")
      @datalist = @groups
   end

   def edit
      respond_to do |format|
         @group = Group.find(params[:id])
         if auth_su || auth_permission(@group.user_id) || auth_permission(@group.admins)
            if @group.admins.nil?
               @group.admins = ""
            end
            if @group.users.nil?
               @group.users = ""
            end
            @users = User.all.order("name")
            format.html {
               render "edit"
            }
         else
            format.html {
               render plain: "You = not allowed", status: 403
            }
            format.js {
               @group.errors.add "base", "You = not allowed"
               @error_object = @group
               render partial: "shared/errors"
            }
         end
      end
   end

   def create
      respond_to do |format|
         group = Group.new(name: params[:add_text])
         group.user_id = current_user_id
         group.admins  = "|" + current_user_id.to_s + "|"
         if group.save
            format.js { render js: "content.callback('" + action_name + "', '" + group.id.to_s + "');" }
         else
            @error_object = group
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         group = Group.find(params[:id])
         if auth_su || auth_permission(group.user_id) || auth_permission(group.admins)
            if group.update(group_params)
               format.js { render js: "content.callback('" + action_name + "', '" + group.id.to_s + "');" }
            end
         else
            group.errors.add "base", "You = not allowed"
         end
         if group.errors.any?
            @error_object = group
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def destroy
      respond_to do |format|
         group = Group.find(params[:id])
         if auth_su || auth_permission(group.admins)
            if group.destroy
               format.js { render js: "content.callback('" + action_name + "', '" + group.id.to_s + "');" }
            end
         else
            group.errors.add "base", "You = not allowed"
         end
         if group.errors.any?
            @error_object = group
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def group_params
      params.require(:group).permit(:name, :settings, :description, :lists, :notes, :image_id)
   end

end



