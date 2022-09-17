class AddForeignKeyToRooms < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :chess_boards, :rooms
    add_foreign_key :chess_boards, :temporary_rooms
  end
end
