


class CreateItems < ActiveRecord::Migration
   def change

      create_table "items" do |t|
         t.integer    "list_id",    null: false
         t.integer    "product_id"
         t.string     "description"
         t.integer    "position"
         t.integer    "priority",   null: false, default: 50
         t.boolean    "checked",    null: false, default: false
         t.integer    "quantity"
         t.integer    "image_id"
         t.text       "notes"
         t.timestamps null: false
      end

#      add_index       "items", ["list_id", "product_id"], unique: true

      add_foreign_key "items", "lists"
      add_foreign_key "items", "products"

   end
end



