


class CreatePermissions < ActiveRecord::Migration
   def change

      create_table "permissions" do |t|
         t.integer    "user_id",     null: false
         t.integer    "object_id",   null: false
         t.integer    "object_type", null: false
         t.string     "permissions", null: false
         t.timestamps null: false
      end

      add_index       "permissions", ["user_id", "object_id", "object_type"], unique: true

      add_foreign_key "permissions", "users"

   end
end



