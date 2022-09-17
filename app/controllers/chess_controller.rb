class ChessController < ApplicationController
  require 'chess.rb'
  require 'chess_in_mem_cache'

  def index
    cache = ChessInMemCache.instance
    @username = cookies['username']

    if params[:id].include? 'temp_'
      @room = TemporaryRoom.find_by_room_id params[:id]
      @user_available = false
    else
      @room = Room.find_by_room_id params[:id]
      @user_available = true
    end

    @board = []

    (0...8).each { |index|
      row = []
      @room.chess_board["row_#{index + 1}"].split(',').each do |col|
        row.push col.split('-')
      end

      @board[index] = row
    }

    @room_name = params[:id]
    cache.store_chess_board(params[:id], @board)

    render 'chess/index'
  end
end