class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_id, null: false, index: { unique: true }
      t.string :room_name, null: false, index: { unique: true }
      t.string :room_host, null: false
      t.string :room_description
      t.string :room_password
      t.string :room_opponent, null: false
      t.string :room_allow_viewers
      t.string :room_privacy
      t.string :room_only_players_chat
      t.timestamps
    end
  end
end
