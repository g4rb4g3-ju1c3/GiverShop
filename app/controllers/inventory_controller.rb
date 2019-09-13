


class InventoryController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
      @vendor    = Vendor.find(params[:vendor_id])
      @inventory = Inventory.select("inventories.*, products.id AS product_id, products.description, products.size, products.notes as product_notes")
                            .joins("LEFT JOIN products ON inventories.product_id = products.id")
                            .where("inventories.vendor_id = ?", @vendor.id)
                            .order("(CASE WHEN inventories.location IS NULL THEN 'zzzzzzzzzz' ELSE inventories.location END) ASC, products.description ASC")
      join_clause = "LEFT JOIN inventories ON inventories.vendor_id = " + @vendor.id.to_s + " AND products.id = inventories.product_id"
      @datalist  = Product.select("products.id AS datalist_list_row_id, inventories.id AS datalist_object_id, products.description AS datalist_text, products.size AS datalist_subtext")
                          .joins(join_clause)
                          .order("products.description ASC")
   end

   def edit
      @inventory = Inventory.find(params[:id])
      if !@inventory.price.nil?
         @inventory.price = "%0.2f" % @inventory.price
      end
      if !@inventory.best_price.nil?
         @inventory.best_price = "%0.2f" % @inventory.best_price
      end
      @vendor   = Vendor   .find(@inventory.vendor_id)
      @product  = Product  .find(@inventory.product_id)
      @datalist = Inventory.select("DISTINCT location AS text")
                           .where("location IS NOT NULL")
                           .order("location ASC")
   end

   def create
      respond_to do |format|
         if !params[:product_id].blank?
            inventory = Inventory.new(vendor_id: params[:vendor_id], product_id: params[:product_id])
         else
            product = Product.new(description: params[:add_text].strip)
            products = Product.select("CONCAT(description, IF(ISNULL(size) OR size = '', '', CONCAT(' - ', size))), id")
                              .where( "CONCAT(description, IF(ISNULL(size) OR size = '', '', CONCAT(' - ', size))) = ?", product.description)
            if products.any?
               product.id = products.first.id
            else
               if !product.save
                  @error_object = product
                  format.js { render partial: "shared/errors" and return }
               end
            end
            inventory = Inventory.new
            inventory.vendor_id  = params[:vendor_id]
            inventory.product_id = product.id
         end
         if inventory.save
            format.js { render js: "content_callback('" + action_name + "', '" + inventory.id.to_s + "');" }
         else
            @error_object = inventory
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         if params[:id_list].blank?
            inventory = Inventory.find(params[:id])
            inventory.update(inventory_params)
         else
            id_list = params[:id_list][1..-1].split("|")
            id_list.each do |inventory_id|
               inventory = Inventory.find(inventory_id)
               if !inventory.update(inventory_params)
                  break
               end
            end
         end
         if !inventory.errors.any?
            format.js { render js: "content_callback('" + action_name + "', '" + inventory.id.to_s + "');" }
         else
            @error_object = inventory
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def destroy
      respond_to do |format|
         if params[:id_list].nil?
            inventory = Inventory.find(params[:id])
            if inventory.destroy
               format.js { render js: "content_callback('" + action_name + "', '" + inventory.id.to_s + "');" }
            else
               @error_object = inventory
               format.js { render partial: "shared/errors" }
            end
         else
            id_list = params[:id_list][1..-1].split("|")
            if Inventory.destroy(id_list)
               format.js { render js: "content_callback('" + action_name + "_multiple', '" + params[:id_list] + "');" }
            else
#               @error_object = inventory
               format.js { render partial: "shared/errors" }
            end
         end
      end
   end

private

   def inventory_params
      params.require(:inventory).permit(:product_id, :vendor_id, :price, :best_price, :location, :notes)
   end

end



