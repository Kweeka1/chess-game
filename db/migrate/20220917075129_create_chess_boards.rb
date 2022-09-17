class CreateChessBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :chess_boards do |t|
      t.string :row_1
      t.string :row_2
      t.string :row_3
      t.string :row_4
      t.string :row_5
      t.string :row_6
      t.string :row_7
      t.string :row_8
      t.timestamps
    end
  end
end
