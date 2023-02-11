class RoomsController < ApplicationController
  before_action :set_room, except: [:index, :new, :create, :search, :room_list, :destroy]
  before_action :authenticate_user!, except: [:show, :index, :search, :room_list]
  before_action :current_user_room,only: %i[index]
  def index
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.create(room_params)
    if !@room.image.attached?
      @room.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default.png')), filename: 'default-image.png', content_type: 'image/png')
    else
      @room.image.attach(params[:room][:image])
    end
    if @room.save
      flash[:notice] = "新規登録しました"
      redirect_to room_path(@room)
    else
      flash[:alert] = "入力してください"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @room.image.attach(params[:room][:image]) if @room.image.blank?
    if @room.update(room_params)
      flash[:notice] = "変更内容を保存しました。"
      redirect_to room_path(@room)
    else
      flash[:alert] = "問題が発生しました。"
      render :edit
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:notice] = "施設を削除しました"
    redirect_to rooms_path
  end

  def photo_upload
  end
  
  def search
    @rooms = Room.search(params[:keyword], params[:method])
    render "room_list"
  end
  
  def room_list
  end
  
  private
    def set_room
      @room = Room.find(params[:id])
      @reservation = Reservation.new
    end
    def room_params
      params.require(:room).permit(:room_name, :room_image, :room_details, :fee, :address, :user_id, :image)
    end
    def current_user_room
      @rooms = Room.where(user_id: current_user.id)
    end

    def default_image
      
    end
end