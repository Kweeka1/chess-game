class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
end
