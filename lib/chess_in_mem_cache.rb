require 'singleton'
require 'redis'

class ChessInMemCache
  include Singleton

  $redis = Redis.new(host: 'localhost')
  USERS_KEY = 'Connected_Users'

  def store_chess_board(id, board)
    $redis.set(id, Marshal.dump(board))
  end

  def get_chess_board(id)
    Marshal.load($redis.get(id))
  end

  def all
    $redis.smembers(USERS_KEY)
  end

  def clear_all
    $redis.del(USERS_KEY)
  end

  def add(uid)
    $redis.sadd(USERS_KEY, uid)
  end

  def include?(uid)
    $redis.sismember(USERS_KEY, uid)
  end

  def remove(uid)
    $redis.srem(USERS_KEY, uid)
  end
end
