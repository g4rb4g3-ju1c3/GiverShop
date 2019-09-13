


class CreateGroups < ActiveRecord::Migration
   def change

      create_table "groups" do |t|
         t.string     "name",        null: false
         t.text       "settings"
         t.string     "description"
         t.string     "lists"
         t.string     "notes"
         t.integer    "image_id"
         t.timestamps null: false
      end

   end
end



