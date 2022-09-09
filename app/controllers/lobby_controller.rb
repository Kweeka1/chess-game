class LobbyController < ApplicationController
  require 'chess_in_mem_cache'
  def index
    user_id = cookies['id']
    @username = cookies['username']

    if !user_id
      id = SecureRandom.uuid
      @username = "Guest#{id[0...8].upcase}"

      cookies['username'] = {
        value: @username,
        expires: Time.now + 3600,
        httponly: true
      }
      cookies['id'] = {
        value: id,
        expires: Time.now + 3600,
        httponly: true
      }
      return render 'index'
    end
  end

  def change_username
    redis = ChessInMemCache.instance
    user_id = cookies['id']
    old_username = cookies['username']
    user = User.find_by user_guid: user_id

    if user
      user.user = username_params
      user.save
    else
      user = User.new
      user.user = username_params
      user.user_guid = user_id
      puts user.user
      user.save
    end

    redis.remove("#{user_id}:#{old_username}")

    cookies['username'] = {
      value: user.user,
      expires: Time.now + 3600,
      httponly: true
    }

    redirect_back(fallback_location: "/")
  end

  private

  def username_params
    params.values_at('user')[0][:user]
  end
end
