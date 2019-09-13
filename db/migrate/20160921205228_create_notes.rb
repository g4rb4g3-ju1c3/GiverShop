


class CreateNotes < ActiveRecord::Migration
   def change

      create_table "notes" do |t|
         t.string     "title", null: false
         t.string     "description"
         t.text       "content"
         t.integer    "image_id"
         t.timestamps null: false
      end

   end
end



