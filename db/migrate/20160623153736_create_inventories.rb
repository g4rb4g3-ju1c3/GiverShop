


class CreateInventories < ActiveRecord::Migration
   def change

      create_table "inventories" do |t|
         t.integer    "vendor_id",  null: false
         t.integer    "product_id", null: false
         t.string     "sku"
         t.integer    "quantity"
         t.decimal    "price",      precision: 11, scale: 2
         t.string     "location"
         t.text       "notes"
         t.timestamps null: false
      end

      add_index       "inventories", ["vendor_id", "product_id"], unique: true

      add_foreign_key "inventories", "vendors"
      add_foreign_key "inventories", "products"

   end
end



