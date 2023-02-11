class UsersController < ApplicationController
  before_action :set_user,only: %i[show profile edit update]
  
  def show
  end
  
  def profile
  end
  
  def edit
  end
  
  def update
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.update(user_params)
      redirect_to profile_path,success: "ユーザーを更新しました"
    else
      flash.now[:danger] = "ユーザーを更新できませんでした"
      render :edit
    end
  end
  
  private
  
    def set_user
      @user = User.find(current_user.id)
    end

    def user_params
      params.require(:user).permit(:email,:profile,:password,:image,:avatar)
    end
end
