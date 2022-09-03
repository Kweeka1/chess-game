class ChessController < ApplicationController
  require 'chess.rb'
  require 'chess_in_mem_cache'

  def index
    cache = ChessInMemCache.instance
    board = cache.get_chess_board(params[:id])
    @room_name = params[:id]
    @board = board
    # File.open("#{Dir.pwd}/log/chess.txt", mode: 'w') do |file|
    #   file << @board[1][0][:piece]
    # end
  end

  def get_board
    cache = ChessInMemCache.instance
    @board = Chess.new.get_board
    id = SecureRandom.uuid[0...5]
    cache.store_chess_board(id, @board)
    redirect_to "/chess/#{id}"
  end
end