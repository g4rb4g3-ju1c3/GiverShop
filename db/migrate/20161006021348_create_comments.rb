


class CreateComments < ActiveRecord::Migration
   def change

      create_table "comments" do |t|
         t.integer    "user_id",     null: false
         t.integer    "object_id",   null: false
         t.integer    "object_type", null: false
         t.string     "content",     null: false
         t.timestamps null: false
      end

      add_foreign_key "comments", "users"

   end
end



