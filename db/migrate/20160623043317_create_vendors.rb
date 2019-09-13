


class CreateVendors < ActiveRecord::Migration
   def change

      create_table "vendors" do |t|
         t.integer    "user_id"
         t.string     "name",     null: false
         t.text       "info"
         t.integer    "image_id"
         t.text       "notes"
         t.timestamps null: false
      end

      add_foreign_key "vendors", "users"

   end
end



