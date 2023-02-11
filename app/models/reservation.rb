class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one_attached :image
  
  validates :checkin_date, presence: true
  validates :checkout_date, presence: true
  validates :guests, presence: true
   
end
