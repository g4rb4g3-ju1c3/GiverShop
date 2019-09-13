


class CreateLists < ActiveRecord::Migration
   def change

      create_table "lists" do |t|
         t.string     "name",        null: false
         t.string     "description"
         t.integer    "image_id"
         t.text       "notes"
         t.timestamps null: false
      end

   end
end



