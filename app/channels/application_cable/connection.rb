module ApplicationCable
  class Connection < ActionCable::Connection::Base
    require 'chess_in_mem_cache'

    identified_by :current_user

    @@redis = ChessInMemCache.instance

    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      id = cookies["id"]
      user = cookies["username"]

      if  id && user
        { id: id, user: user }
      else
        reject_unauthorized_connection
      end
    end
  end
end
