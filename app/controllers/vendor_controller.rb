


class VendorController < ApplicationController

   before_filter "auth_login"

   layout Proc.new { |controller| controller.request.xhr? ? "body_only" : "application" }

   def index
      @vendors  = Vendor.select("*, id AS datalist_list_row_id, '' AS datalist_object_id, name AS datalist_text, NULL AS datalist_subtext")
                        .order("name ASC")
      @datalist = @vendors
   end

   def edit
      @vendor = Vendor.find(params[:id])
   end

   def create
      respond_to do |format|
         if !params[:add_text].nil?
            vendor = Vendor.new(name: params[:add_text])
         else
            vendor = Vendor.new(vendor_params)
         end
         if vendor.save
            format.js { render js: "content_callback('" + action_name + "', '" + vendor.id.to_s + "');" }
         else
            @error_object = vendor
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def update
      respond_to do |format|
         vendor = Vendor.find(params[:id])
         if vendor.update(vendor_params)
            format.js { render js: "content_callback('" + action_name + "', '" + vendor.id.to_s + "');" }
         else
            @error_object = vendor
            format.js { render partial: "shared/errors" }
         end
      end
   end

   def destroy
      respond_to do |format|
         vendor = Vendor.find(params[:id])
         if vendor.destroy
            format.js { render js: "content_callback('" + action_name + "', '" + vendor.id.to_s + "');" }
         else
            @error_object = vendor
            format.js { render partial: "shared/errors" }
         end
      end
   end

private

   def vendor_params
      params.require(:vendor).permit(:name, :info, :image_id, :notes)
   end

end



