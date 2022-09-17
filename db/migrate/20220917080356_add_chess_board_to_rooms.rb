class AddChessBoardToRooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :chess_boards, :room
    add_reference :chess_boards, :temporary_room
  end
end
