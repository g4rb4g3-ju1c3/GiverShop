


class ListController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
      @lists = Permission.select("permissions, lists.*, " +
                                 "lists.id AS datalist_list_row_id, NULL AS datalist_object_id, lists.name AS datalist_text, NULL AS datalist_subtext")
                         .joins("LEFT JOIN lists ON lists.id = permissions.object_id")
                         .where("permissions.user_id = ? AND permissions.object_type = ?", current_user_id, OBJ_LIST)
                         .order("name ASC")
      @datalist = @lists
   end

   def show
      respond_to do |format|
         # Find the list:
         @list = find_list(params[:id], nil)
         if !@list.nil?
            # Get vendors available to the current user:
            @vendors = Vendor.all
                             .where("user_id IS NULL OR user_id = ?", current_user_id)
                             .order("name")
            # Vendor to organize the list by:
            @vendor_id = params[:vendor_id]
            if @vendor_id.blank?
               @vendor_id = session["list_" + @list.id.to_s + "_vendor_id"]
               if @vendor_id.blank?
                  vendor = @vendors.first
                  if !vendor.nil?
                     @vendor_id = vendor.id.to_s
                  end
               end
            end
            session["list_" + @list.id.to_s + "_vendor_id"] = @vendor_id
            # The main shiznit:
            join_clause = "LEFT JOIN inventories ON " +
                          (@vendor_id.nil? ? "" : "inventories.vendor_id = " + @vendor_id + " AND ") +
                          "inventories.product_id = items.product_id"
            @items = Item.select("items.id, items.product_id, items.priority, items.quantity, items.checked, items.notes,
                                  IF(items.product_id, products.description, items.description) AS description, products.size, products.notes AS product_notes,
                                  inventories.vendor_id, inventories.price, inventories.location")
                         .joins("LEFT JOIN products ON items.product_id = products.id")
                         .joins(join_clause)
                         .where("items.list_id = ? AND (inventories.vendor_id = ? OR inventories.vendor_id IS NULL)", @list.id, @vendor_id.nil? ? "NULL" : @vendor_id)
                         .order("(CASE WHEN inventories.location IS NULL THEN 'zzzzzzzzzz' ELSE inventories.location END), description ASC")
            # Locations datalist (uses the same join clause):
#            if @vendor_id.nil?
#               @locations_datalist = nil
#            else
#               @locations_datalist = Item.select("DISTINCT inventories.location")
#                                         .joins(join_clause)
#                                         .where("items.list_id = ? AND (vendor_id = ? OR vendor_id IS NULL)", @list.id, @vendor_id)
#                                         .order("(CASE WHEN location IS NULL THEN 'zzzzzzzzzz' ELSE location END) ASC")
#            end
            # Products datalist:
#            join_clause = "LEFT JOIN items ON items.list_id = " + @list.id.to_s + " AND items.product_id = products.id"
#            @datalist = Product.select("products.id AS datalist_item_id, items.id AS existing_item_id, products.description AS text, products.size AS subtext")
#                               .joins(join_clause)
#                               .order("products.description ASC")
            @datalist = Item.find_by_sql(
               "(SELECT items.id AS datalist_list_row_id, products.id AS datalist_object_id, IF(product_id, products.description, items.description) AS datalist_text, products.size AS datalist_subtext " +
                  "FROM items " +
                  "LEFT JOIN products ON items.product_id = products.id " +
                  "WHERE items.list_id = " + @list.id.to_s + ") " +
               "UNION DISTINCT " +
               "(SELECT items.id AS datalist_list_row_id, products.id AS datalist_object_id, products.description AS datalist_text, products.size AS datalist_subtext " +
                  "FROM items " +
                  "RIGHT JOIN products ON products.id = items.product_id " +
                  "WHERE (items.id IS NULL OR items.list_id = " + @list.id.to_s + ") " +
                    "AND (products.user_id IS NULL OR products.user_id = " + current_user_id.to_s + ")) " +
               "ORDER BY datalist_text ASC"
            )
            format.html { render "show" }
         else
            format.html { render plain: "You = not allowed", status: 403 }
            format.js {
               @list.errors.add "base", "You = not allowed"
               @error_object = @list
               render partial: "shared/errors"
            }
         end
      end
   end

   def edit
      respond_to do |format|
         @list = find_list(params[:id], "LE")
         if !@list.nil?
            @users = Permission.select("permissions, users.*")
                               .joins("LEFT JOIN users ON users.id = permissions.user_id")
                               .where("permissions.user_id != ? AND permissions.object_id = ? AND permissions.object_type = ?", current_user_id, @list.id.to_s, OBJ_LIST)
                               .order("users.name ASC")
            format.html { render "edit" }
         else
            @list.errors.add "base", "You = not allowed"
         end
         if @list.errors.any?
            format.html { render plain: "You = not allowed", status: 403 }
            format.js   { render js:    "show_error('You = not allowed');" }
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

   def create
      respond_to do |format|
         list = List.new(name: params[:add_text])
         if list.save
            permission = Permission.new(user_id: current_user_id, object_id: list.id, object_type: OBJ_LIST, permissions: "|LC|LE|LD|LIC|LIA|LIE|LID|")
            if permission.save
               format.js { render js: "content.callback('" + action_name + "', '" + list.id.to_s + "');" }
            else
               @error_object = permission
               format.js { render partial: "shared/errors" }
            end
         else
            @error_object = list
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         list = find_list(params[:id], "LE")
         if !list.nil?
            if list.update(list_params)
               format.js { render js: "content.callback('" + action_name + "', '" + list.id.to_s + "');" }
            end
         else
            list.errors.add "base", "You = not allowed"
         end
         if list.errors.any?
            @error_object = list
            format.js { render partial: "shared/errors" }
         end
       end
   end

   def destroy
      respond_to do |format|
         list = find_list(params[:id], "LD")
         if !list.nil?
            if list.destroy
               format.js { render js: "content.callback('" + action_name + "', '" + list.id.to_s + "');" }
            end
         else
            list.errors.add "base", "You = not allowed"
         end
         if list.errors.any?
            @error_object = list
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def find_list(list_id, permission)
      if !list_id.nil?
         list = Permission.select("permissions, lists.*")
                          .joins("LEFT JOIN lists ON lists.id = permissions.object_id")
                          .where("permissions.user_id = ? AND permissions.object_id = ? AND permissions.object_type = ?", current_user_id, list_id.to_s, OBJ_LIST)
         if list.any?
            list = list.first
            if !list.permissions.nil?
               if permission.nil? || auth_permission(@list, permission) || auth_su
                  return list
               end
            end
         end
      end
      return nil
   end

   def list_params
      params.require(:list).permit(:name, :description, :image_id, :notes)
   end

end



