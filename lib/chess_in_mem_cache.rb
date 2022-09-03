require 'singleton'
require 'redis'

class ChessInMemCache
  include Singleton

  $redis = Redis.new(host: 'localhost')

  def store_chess_board(id, board)
    $redis.set(id, Marshal.dump(board))
  end

  def get_chess_board(id)
    Marshal.load($redis.get(id))
  end
end
