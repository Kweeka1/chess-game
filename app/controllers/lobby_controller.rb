class LobbyController < ApplicationController
  require 'chess_in_mem_cache'
  require 'chess'
  before_action :room_viewers_options, :room_chat_options, :room_privacy_options
  def index
    user_id = cookies['id']
    @username = cookies['username']
    registered = User.find_by user_id: user_id

    if registered
      @user_available = true
      @room = Room.new
      cookies['username'] = {
        value: registered[:user],
        expires: Time.now.next_year,
        httponly: true
      }
      cookies['id'] = {
        value: user_id,
        expires: Time.now.next_year,
        httponly: true
      }

      return render 'index'
    elsif !user_id
      id = SecureRandom.uuid
      @username = "Guest#{id[0...8].upcase}"
      @room = TemporaryRoom.new

      cookies['username'] = {
        value: @username,
        expires: Time.now.next_day,
        httponly: true
      }
      cookies['id'] = {
        value: id,
        expires: Time.now.next_day,
        httponly: true
      }

      return render 'index'
    end

    @room = TemporaryRoom.new
  end

  def create_room
    @username = cookies['username']
    registered = User.find_by user: @username

    if registered
      @room = registered.rooms.new
      @room[:room_id] = create_room_params[:room_name].strip.gsub(/[^0-9a-z]/i, '_')
    else
      @room = TemporaryRoom.new
      @room[:room_host] = @username
      @room[:room_id] = "temp_#{create_room_params[:room_name].strip.gsub(/[^0-9a-z]/i, '_')}"
    end

    @room[:room_name] = create_room_params[:room_name]
    @room[:room_description] = create_room_params[:room_description]
    @room[:room_password] = create_room_params[:room_password]
    @room[:room_opponent] = create_room_params[:room_opponent]
    @room[:room_allow_viewers] = create_room_params[:room_allow_viewers]
    @room[:room_privacy] = create_room_params[:room_privacy]
    @room[:room_only_players_chat] = create_room_params[:room_only_players_chat]

    board = Chess.new.get_board
    chess_board = ChessBoard.new

    (0...8).each { |index|
      chess_board["row_#{index + 1}"] = board[index].join(',')
    }

    @room.chess_board = chess_board

    if @room.save
      redirect_to "/chess/#{@room[:room_id]}"
    else
      render :'lobby/index', status: :unprocessable_entity
    end
  end

  def change_username
    redis = ChessInMemCache.instance
    user_id = cookies['id']
    old_username = cookies['username']
    user = User.find_by user_id: user_id

    if user
      user.user = username_params
      user.save
    else
      user = User.new
      user.user = username_params
      user.user_id = user_id
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
