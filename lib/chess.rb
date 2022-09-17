class Chess

  Blue_Backline = %w[Rock_black-Blue Knight_black-Blue Bishop_black-Blue King_black-Blue Queen_black-Blue Bishop_black-Blue Knight_black-Blue Rock_black-Blue]

  Red_Backline = %w[Rock_white-Red Knight_white-Red Bishop_white-Red King_white-Red Queen_white-Red Bishop_white-Red Knight_white-Red Rock_white-Red]

  def initialize
    @board = Array.new(8) do |row|
      Array.new(8) do |col|
        if row == 0
          Blue_Backline[col] = Blue_Backline[col] + "-#{row}:#{col}"
          Blue_Backline[col]
        elsif row == 1
          "Pawn_black-Blue-#{row}:#{col}"
        elsif row == 6
          "Pawn_white-Red-#{row}:#{col}"
        elsif row == 7
          Red_Backline[col] = Red_Backline[col] + "-#{row}:#{col}"
          Red_Backline[col]
        else
          "--#{row}:#{col}"
        end
      end
    end
  end

  def get_board
    @board
  end

  private

  TABLE = {
    A: '0',
    B: '1',
    C: '2',
    D: '3',
    E: '4',
    F: '5',
    G: '6',
    H: '7'
  }.freeze

end
