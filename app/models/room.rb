class Room < ApplicationRecord
  validates :room_id, uniqueness: true
  validates :room_name, uniqueness: true, length: { maximum: 30, minimum: 5 }
  validates :room_password, allow_blank: true, length: { maximum: 24, minimum: 6 }
  validates :room_description, length: { maximum: 105 }
  validates :room_allow_viewers, inclusion: {in: %w(allow permission no)}
  validates :room_only_players_chat, inclusion: {in: %w(players all)}
  validates :room_privacy, inclusion: {in: %w(public private)}
end
