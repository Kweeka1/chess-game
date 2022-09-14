class LobbyController < ApplicationController
  require 'chess_in_mem_cache'
  require 'chess'
  before_action :room_viewers_options, :room_chat_options, :room_privacy_options
  def index
    user_id = cookies['id']
    @username = cookies['username']
    @room = Room.new

    if !user_id
      id = SecureRandom.uuid
      @username = "Guest#{id[0...8].upcase}"

      cookies['username'] = {
        value: @username,
        expires: Time.now.next_year,
        httponly: true
      }
      cookies['id'] = {
        value: id,
        expires: Time.now.next_year,
        httponly: true
      }

      File.open("#{Dir.getwd}/log/logs.txt", mode = 'w') do |logs|
        logs << "[#{Time.now}]: Connection from #{@username} with IP address #{request.remote_ip} with Id #{id}"
      end

      render 'index'
    end
  end

  def create_room
    @room = Room.new

    @room[:room_id] = create_room_params[:room_name].to_s.strip.gsub(/[^0-9a-z]/i, '_')
    @room[:room_name] = create_room_params[:room_name]
    @room[:room_description] = create_room_params[:room_description]
    @room[:room_password] = create_room_params[:room_password]
    @room[:room_opponent] = create_room_params[:room_opponent]
    @room[:room_allow_viewers] = create_room_params[:room_allow_viewers]
    @room[:room_privacy] = create_room_params[:room_privacy]
    @room[:room_only_players_chat] = create_room_params[:room_only_players_chat]

    if @room.save
      cache = ChessInMemCache.instance
      @board = Chess.new.get_board
      cache.store_chess_board(@room[:room_id], @board)

      @room_id = @room[:room_id]
      redirect_to "/chess/#{@room[:room_id]}"
    else
      File.open("#{Dir.getwd}/log/logs.txt", mode = 'w') do |logs|
        logs << "#{@room.errors.inspect}\n"
      end
      puts @room.errors.inspect
      render :'lobby/index', status: :unprocessable_entity
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

  def room_privacy_options
    @privacy_types = {
      Public: 'public',
      Private: 'private'
    }
  end

  def room_viewers_options
    @viewers_access_types = {
      "Free to join": 'allow',
      "By permission": 'permission',
      "No viewers": 'no'
    }
  end

  def room_chat_options
    @chat_access_types = {
      "Only players": 'players',
      "Viewers and players": 'all',
    }
  end

  def create_room_params
    params.require(:room).permit(:room_name, :room_privacy, :room_opponent, :room_password, :room_description, :room_allow_viewers, :room_only_players_chat)
  end
end
