class Chess
  Blue_Rock = { "piece": 'Rock_black', team: 'Blue' }.freeze
  Blue_Knight = { "piece": 'Knight_black', team: 'Blue' }.freeze
  Blue_Bishop = { "piece": 'Bishop_black', team: 'Blue' }.freeze
  Blue_King = { "piece": 'King_black', team: 'Blue' }.freeze
  Blue_Queen = { "piece": 'Queen_black', team: 'Blue' }.freeze
  Blue_Pawn = { "piece": 'Pawn_black', team: 'Blue' }.freeze

  Red_Rock = { "piece": 'Rock_white', team: 'Red' }.freeze
  Red_Knight = { "piece": 'Knight_white', team: 'Red' }.freeze
  Red_Bishop = { "piece": 'Bishop_white', team: 'Red' }.freeze
  Red_King = { "piece": 'King_white', team: 'Red' }.freeze
  Red_Queen = { "piece": 'Queen_white', team: 'Red' }.freeze
  Red_Pawn = { "piece": 'Pawn_white', team: 'Red' }.freeze

  Blue_Backline = [Blue_Rock, Blue_Knight, Blue_Bishop, Blue_King, Blue_Queen, Blue_Bishop, Blue_Knight, Blue_Rock]
  Red_Backline = [Red_Rock, Red_Knight, Red_Bishop, Red_King, Red_Queen, Red_Bishop, Red_Knight, Red_Rock]

  Blue_Frontline = Array.new 8, Blue_Pawn
  Red_Frontline = Array.new 8, Red_Pawn

  def initialize
    @board = Array.new(8, Array.new(8, '  '))
    @board[0] = Blue_Backline
    @board[1] = Blue_Frontline
    @board[6] = Red_Frontline
    @board[7] = Red_Backline
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
