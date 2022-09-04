class Chess

  Blue_Backline = [{ "piece": 'Rock_black', team: 'Blue' },
                   { "piece": 'Knight_black', team: 'Blue' },
                   { "piece": 'Bishop_black', team: 'Blue' },
                   { "piece": 'King_black', team: 'Blue' },
                   { "piece": 'Queen_black', team: 'Blue' },
                   { "piece": 'Bishop_black', team: 'Blue' },
                   { "piece": 'Knight_black', team: 'Blue' },
                   { "piece": 'Rock_black', team: 'Blue' }]

  Red_Backline = [{ "piece": 'Rock_white', team: 'Red' },
                   { "piece": 'Knight_white', team: 'Red' },
                   { "piece": 'Bishop_white', team: 'Red' },
                   { "piece": 'King_white', team: 'Red' },
                   { "piece": 'Queen_white', team: 'Red' },
                   { "piece": 'Bishop_white', team: 'Red' },
                   { "piece": 'Knight_white', team: 'Red' },
                   { "piece": 'Rock_white', team: 'Red' }]

  def initialize
    @board = Array.new(8) do |row|
      Array.new(8) do |col|
        if row == 0
          Blue_Backline[col][:id] = "#{row}:#{col}"
          Blue_Backline[col]
        elsif row == 1
          { "piece": 'Pawn_black', team: 'Blue', id: "#{row}:#{col}" }
        elsif row == 6
          { "piece": 'Pawn_white', team: 'Red', id: "#{row}:#{col}" }
        elsif row == 7
          Red_Backline[col][:id] = "#{row}:#{col}"
          Red_Backline[col]
        else
          {piece: '', team: '', id: "#{row}:#{col}" }
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
