


class CreateUsers < ActiveRecord::Migration
   def change

      create_table "users" do |t|
         t.string     "username",        null: false, unique: true
         t.string     "password_digest", null: false, unique: true
         t.text       "settings"
         t.string     "name"
         t.string     "phone"
         t.string     "email"
         t.integer    "image_id"
         t.text       "notes"
         t.string     "recent"
         t.timestamp  "last_login_at"
         t.timestamps null: false
      end

   end
end



