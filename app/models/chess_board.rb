class ChessBoard < ApplicationRecord
  belongs_to :room, optional: true
  belongs_to :temporary_room, optional: true
end
