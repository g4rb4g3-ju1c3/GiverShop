


class ProductController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
      @products = Product.select("*, id AS datalist_list_row_id, '' AS datalist_object_id, description AS datalist_text, size AS datalist_subtext")
                         .where("user_id IS NULL OR user_id = ?", current_user_id)
                         .order("description ASC, size ASC")
      @datalist = @products
   end

   def edit
      @product = Product.find(params[:id])
      inventory_join_clause = "LEFT JOIN inventories ON inventories.vendor_id = vendors.id AND inventories.product_id = " + @product.id.to_s
      @inventories = Vendor.select("vendors.id as vendor_id, vendors.name, inventories.id, inventories.price, inventories.best_price, inventories.location")
                           .joins(inventory_join_clause)
                           .order("ISNULL(inventories.id) ASC, vendors.name ASC")
   end

   def create
      respond_to do |format|
         product = Product.new(description: params[:add_text])
         if product.save
            format.js { render js: "content_callback('" + action_name + "', '" + product.id.to_s + "');" }
         else
            @error_object = product
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         if params[:id_list].nil?
            product = Product.find(params[:id])
            if product.update(product_params)
               format.js { render js: "content_callback('" + action_name + "', '" + product.id.to_s + "');" }
               format.js { render js: "history.back();" }
            else
               @error_object = product
               format.js { render partial: "shared/errors" }
            end
         else
            id_list = params[:id_list][1..-1].split("|")
            id_list.each do |product_id|
               inventory = Inventory.where(vendor_id: params[:vendor_id], product_id: product_id).first
               if inventory.nil?
                  inventory = Inventory.new(inventory_params)
                  inventory.vendor_id  = params[:vendor_id]
                  inventory.product_id = product_id
                  inventory.save
               else
                  inventory.update(inventory_params)
               end
               if inventory.errors.any?
                  @error_object = inventory
                  format.js { render partial: "shared/errors" and return }
               end
            end
            format.js { render js: "refresh_content();" }
         end
      end
   end

   def destroy
      respond_to do |format|
         if params[:id_list].nil?
            product = Product.find(params[:id])
            if product.destroy
               format.js { render js: "content_callback('" + action_name + "', '" + product.id.to_s + "');" }
            else
               @error_object = product
               format.js { render partial: "shared/errors" }
            end
         else
            id_list = params[:id_list][1..-1].split("|")
            if Product.destroy(id_list)
               format.js { render js: "content_callback('" + action_name + "_multiple', '" + product.id.to_s + "');" }
            else
#               @error_object = inventory
               format.js { render partial: "shared/errors" }
            end
         end
      end
   end

private

   def product_params
      params.require(:product).permit(:description, :size, :notes)
   end

   def inventory_params
      params.require(:inventory).permit(:product_id, :vendor_id, :price, :location, :notes)
   end

end



