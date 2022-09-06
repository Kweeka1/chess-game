class LobbyController < ApplicationController
  def index
    user_id = cookies['id']
    username = cookies['username']

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

    if !username
      user = User.find_by id: user_id

      if user
        @username = user.user
        cookies['username'] = {
          value: @username,
          expires: Time.now + 3600,
          httponly: true
        }
      end

      return render 'index'
    end
  end

  def change_username
    user_id = cookies['id']
    @user = User.find_by id: user_id

    params.values_at('user').each_slice(1) do |vl|
      puts 'params', vl[0].instance_of?(Hash)
      puts 'params', vl[0].instance_of?(Integer)
      puts 'params', vl[0].instance_of?(Float)
      puts 'params', vl[0].instance_of?(Array)
      puts 'params', vl[0].instance_of?(Symbol)
      puts vl[0]
    end

    if @user
      @user.user = params.values_at('user')
      @user.save
    else
      @user = User.new
      @user.user = username_params
      @user.id = user_id
      @user.save
    end

    cookies['username'] = {
      value: @user,
      expires: Time.now + 3600,
      httponly: true
    }
    redirect_to '/'
  end

  private

  def username_params
    params[:user][:user]
  end
end
