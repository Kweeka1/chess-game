class ChessController < ApplicationController
  require 'chess.rb'
  require 'chess_in_mem_cache'

  def index
    cache = ChessInMemCache.instance
    board = cache.get_chess_board(params[:id])
    @room_name = params[:id]
    @board = board
    render 'chess/index'
  end
end