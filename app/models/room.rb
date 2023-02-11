class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations ,dependent: :destroy
  has_one_attached :image
  validates :room_name, presence: true
  validates :room_details, presence: true
  validates :fee, presence: true
  validates :address, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "有効なフォーマットではありません" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }
  
  def self.search(keyword, method)
    if method== 'area'
      where(["address like?", "%#{keyword}%"])
    elsif method == 'key'
      where(["room_name like? OR room_details like?", "%#{keyword}%", "%#{keyword}%"])
    else
      where(["room_name like? OR address like? OR room_details like?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
    end
  end
end