class User < ApplicationRecord
  has_many :rooms
  has_many :reservations
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "有効なフォーマットではありません" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }
  
  def update_without_current_password(params, *options)
    if params[:name] != nil
      params.delete(:current_password)
      if params[:password].blank? && params[:password_confirmation].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
      end
  
      result = update(params, *options)
      clean_up_passwords
      result
    else
      current_password = params.delete(:current_password)

      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
      end
    
      result = if valid_password?(current_password)
        update(params, *options)
      else
        assign_attributes(params, *options)
        valid?
        errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end
    
      clean_up_passwords
      result
    end
  end
end

  
