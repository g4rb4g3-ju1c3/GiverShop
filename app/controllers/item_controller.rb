


class ItemController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def quick_edit
      if request.xhr?
         @item = Item.find(params[:id])
         @comments = Comment.select("content")
                            .where("user_id = ? AND object_id = ? AND object_type = ?", current_user_id, @item.id, OBJ_COMMENT)
         @comment  = Comment.new(user_id:     current_user_id,
                                 object_id:   @item.id,
                                 object_type: OBJ_COMMENT)
         if !params[:vendor_id].blank?
            @vendor = Vendor.find(params[:vendor_id])
         else
            @vendor = nil
         end
         if !@item.product_id.blank?
            @product = Product.find(@item.product_id)
            if !@product.nil?
               @inventory = Inventory.select("*")
                                     .where("vendor_id = ? AND product_id = ?", @vendor.id, @product.id)
               if @inventory.any?
                  @inventory = @inventory.first
                  if !@inventory.price.nil?
                     @inventory.price = "%0.2f" % @inventory.price
                  end
               else
                  @inventory = Inventory.new(product_id: @product.id)
               end
            else
               @error_object = @product
               render partial: "shared/errors" and return
            end
         else
            @product   = Product.new(description: @item.description)
            @inventory = Inventory.new
            if !@vendor.nil?
               @inventory.vendor_id = @vendor.id
            end
         end
         @datalist = Inventory.select("DISTINCT location AS text")
                              .joins("INNER JOIN products ON products.id = inventories.product_id")
                              .where("(products.user_id IS NULL OR products.user_id = ?) AND products.id = inventories.product_id AND location IS NOT NULL", current_user_id)
                              .order("location ASC")
         render partial: "quick_edit"
      end
   end

   def edit
      @list    = List   .find(params[:list_id])
      @item    = Item   .find(params[:id])
      @product = Product.find(@item.product_id)
   end

   def create
      respond_to do |format|
#         product_id = params[:product_id]
#         if product_id.blank?
#            product  = Product.new(user_id: current_user_id, description: params[:add_text].strip)
#            products = Product.select("CONCAT(description, IF(ISNULL(size) OR size = '', '', CONCAT(' ', size))), id")
#                              .where( "CONCAT(description, IF(ISNULL(size) OR size = '', '', CONCAT(' ', size))) = ?", product.description)
#            if products.any?
#               product_id = products.first.id
#            else
#               if product.save
#                  product_id = product.id
#               else
#                  @error_object = product
#                  format.js { render partial: "shared/errors" and return }
#               end
#            end
#         end
#         item = Item.new(list_id: params[:list_id], product_id: product_id)
         if params[:product_id].blank?
            item = Item.new(list_id: params[:list_id], description: params[:add_text].strip)
         else
            item = Item.new(list_id: params[:list_id], product_id: params[:product_id])
         end
         if item.save
            @item = select_item(item.id, params[:vendor_id])
            if @item.location.blank?
               @item.location = "Miscellaneous"
            end
            format.js { render partial: "create" }
         else
            @error_object  = item
            @existing_item = Item.select("id")
                                 .where("list_id = ? AND (description = ? OR product_id = ?", params[:list_id], params[:add_text], product_id.nil? ? "NULL" : product_id.to_s)
                                 .first
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def quick_update
      respond_to do |format|
         item = Item.find(params[:id])
         if item.update(item_params)
            inventory = Inventory.new(inventory_params)
            if inventory.id.nil? && !inventory.vendor_id.nil?
               if !inventory.price.nil? || !inventory.location.blank?
                  inventory.save
               end
            else
               inventory = Inventory.find(inventory.id)
               inventory.update(inventory_params)
            end
            if inventory.nil? || inventory.errors.none?
               @item = select_item(item.id, params[:vendor_id])
               format.js { render partial: "quick_update" }
            else
               @error_object = inventory
               format.js { render partial: "shared/errors" }
            end
         else
            @error_object = item
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         item = Item.find(params[:id])
         if item.update(item_params)
            format.js { render js: "content.callback('" + action_name + "', '" + item.id.to_s + "');" }
         else
            @error_object = item
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def destroy
      respond_to do |format|
         item = Item.find(params[:id])
         if item.destroy
            format.js { render js: "content.callback('" + action_name + "', { item_id: '" + item.id.to_s + "', product_id: '" + item.product_id.to_s + "' });" }
         else
            @error_object = item
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def item_params
      params.require(:item).permit(:list_id, :product_id, :position, :priority, :quantity, :checked, :notes)
   end

   def inventory_params
      params.require(:inventory).permit(:id, :vendor_id, :product_id, :price, :location, :notes)
   end

   def select_item(item_id, vendor_id)
      join_clause = "LEFT JOIN inventories ON inventories.vendor_id = " + (vendor_id.blank? ? "NULL" : vendor_id.to_s) + " AND inventories.product_id = items.product_id"
      return Item.select("items.id, items.list_id, items.product_id, items.priority, items.quantity, items.checked, items.notes,
                         products.description, products.size, products.origin, products.notes as product_notes,
                         inventories.vendor_id, inventories.price, inventories.location")
                 .joins("INNER JOIN products ON items.product_id = products.id")
                 .joins(join_clause)
                 .where("items.id = ?", item_id)
                 .first
   end

end



