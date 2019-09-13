


class CreateProducts < ActiveRecord::Migration
   def change

      create_table "products" do |t|
         t.integer    "user_id"
         t.string     "description", null: false
         t.string     "size"
         t.string     "model"
         t.string     "upc"
         t.string     "origin"
         t.integer    "image_id"
         t.text       "notes"
         t.timestamps null: false
      end

      add_foreign_key "products", "users"

   end
end



