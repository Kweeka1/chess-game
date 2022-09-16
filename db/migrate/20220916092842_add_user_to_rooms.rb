class AddUserToRooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :rooms, :user
  end
end
