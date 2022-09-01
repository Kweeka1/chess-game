class ChessController < ApplicationController
  require 'chess.rb'
  def index
    game = Chess.new
    @board = game.get_board
    # File.open("#{Dir.pwd}/log/chess.txt", mode: 'w') do |file|
    #   file << @board[1][0][:piece]
    # end
  end
end