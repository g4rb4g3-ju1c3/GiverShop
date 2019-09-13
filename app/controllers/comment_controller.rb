


class CommentController < ApplicationController

#   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def create
      respond_to do |format|
         comment = Comment.new(comment_params)
         if comment.save
            format.js { render js: "alert('nigs');" }
         else
            @error_object = comment
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def destroy
      respond_to do |format|
         comment = Comment.find(params[:id])
#         if auth_su || auth_permission(group.admins)
            if group.destroy
               format.js { render js: "content.callback('" + action_name + "', '" + comment.id.to_s + "');" }
            end
#         else
#            group.errors.add "base", "You = not allowed"
#         end
         if comment.errors.any?
            @error_object = comment
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def comment_params
      params.require(:comment).permit(:user_id, :object_id, :object_type, :content)
   end

end



