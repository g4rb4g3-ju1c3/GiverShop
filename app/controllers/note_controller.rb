


class NoteController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
#      if auth_su
#         @notes = Permission.select("permissions, notes.*, " +
#                                    "notes.id AS datalist_list_row_id, NULL AS datalist_object_id, notes.title AS datalist_text, NULL AS datalist_subtext")
#                            .joins("LEFT JOIN notes ON notes.id = object_id")
#                            .where("object_type = ?", OBJ_NOTE)
#                            .order("title ASC")
#      else
         @notes = Permission.select("permissions, notes.*, " +
                                    "notes.id AS datalist_list_row_id, NULL AS datalist_object_id, notes.title AS datalist_text, NULL AS datalist_subtext")
                            .joins("LEFT JOIN notes ON notes.id = object_id")
                            .where("object_type = ? AND user_id = ?", OBJ_NOTE, current_user_id)
                            .order("title ASC")
#      end
      @datalist = @notes
   end

   def show
      respond_to do |format|
         @note = find_note(params[:id], nil)
         if !@note.nil?
            format.html { render "show" }
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def edit
      respond_to do |format|
         @note = find_note(params[:id], "NE")
         if !@note.nil?
            @users = Permission.select("permissions, users.*")
                               .joins("LEFT JOIN users ON users.id = permissions.user_id")
                               .where("permissions.user_id != ? AND permissions.object_id = ? AND permissions.object_type = ?", current_user_id, @note.id.to_s, OBJ_NOTE)
                               .order("users.name ASC")
            format.html { render "edit" }
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def share
      respond_to do |format|
         user = User.find_by_email(params[:email])
         if user
            format.js { render js: "show_dialog('" + user.username + ": " + user.email + "', { close_button: true });" }
         else
            format.js { render js: "show_dialog('" + params[:email] + " not found.', { close_button: true });" }
         end
      end
   end

   def download
      respond_to do |format|
         note = find_note(params[:id], nil)
         if !note.nil?
            send_data note.content, filename: note.title + ".txt", type: "text/plain"
            return
         else
            format.html { render html: "You = not allowed", status: 403 }
            format.js   { render js:   "show_error('You = not allowed');" }
         end
      end
   end

   def create
      respond_to do |format|
         note = Note.new(title: params[:add_text])
         if note.save
            permission = Permission.new(user_id: current_user_id, object_id: note.id, object_type: OBJ_NOTE, permissions: "|NC|NE|ND|")
            if permission.save
               format.js { render js: "content.callback('" + action_name + "', '" + note.id.to_s + "');" }
            else
               @error_object = permission
               format.js { render partial: "shared/errors" }
            end
         else
            @error_object = note
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         note = find_note(params[:id], "NE")
         if !note.nil?
            if note.update(note_params)
               format.js { render js: "content.callback('" + action_name + "', '" + params[:update_action] + "');" }
            else
               @error_object = note
               format.js { render partial: "shared/errors" }
            end
         else
            note.errors.add "base", "You = not allowed"
         end
         if note.errors.any?
            @error_object = note
            format.js { render partial: "shared/errors" }
         end
       end
   end

   def destroy
      respond_to do |format|
         note = find_note(params[:id], "ND")
         if !note.nil?
            if note.destroy
               format.js { render js: "content.callback('" + action_name + "', '" + note.id.to_s + "');" }
            end
         else
            note.errors.add "base", "You = not allowed"
         end
         if note.errors.any?
            @error_object = note
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def find_note(note_id, permission)
      if !note_id.nil?
         note = Permission.select("permissions, notes.*")
                          .joins("LEFT JOIN notes ON notes.id = permissions.object_id")
                          .where("permissions.user_id = ? AND permissions.object_id = ? AND permissions.object_type = ?", current_user_id, note_id.to_s, OBJ_NOTE)
         if note.any?
            note = note.first
            if !note.permissions.nil?
               if permission.nil? || auth_permission(@list, permission) || auth_su
                  return note
               end
            end
         end
      end
      return nil
   end

   def note_params
      params.require(:note).permit(:title, :description, :content, :image_id)
   end

end



