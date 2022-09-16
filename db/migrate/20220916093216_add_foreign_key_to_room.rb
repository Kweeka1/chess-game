class AddForeignKeyToRoom < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :rooms, :users
  end
end
