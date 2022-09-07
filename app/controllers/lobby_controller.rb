class LobbyController < ApplicationController
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
    user_id = cookies['id']
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

    cookies['username'] = {
      value: user.user,
      expires: Time.now + 3600,
      httponly: true
    }
    redirect_to '/'
  end

  private

  def username_params
    puts params.values_at('user')[0][:user]
    params.values_at('user')[0][:user]
  end
end
