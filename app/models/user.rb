class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_one :chess_board, through: :rooms
end
