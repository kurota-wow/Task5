class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, except: [:show, :new, :create, :confirm, :edit, :destroy]
  
  def show
    @reservations = current_user.reservations.order(checkin_date: :asc)
  end

  def confirm
    @user_id = current_user.id
    @reservation = Reservation.new(reservation_params)
    if @reservation.invalid?
      redirect_to room_path(@reservation.room_id), alert: '予約情報が不足しています'
    elsif @reservation.checkout_date <= @reservation.checkin_date
      redirect_to room_path(@reservation.room_id), alert: '過去と当日の日付は選択できません'
    elsif @reservation.guests.to_i <= 0
      redirect_to room_path(@reservation.room_id), alert: '人数には数字を入力してください'
    else
      count_totalprice_and_staydays
    end
  end
  
  def edit_confirm
    @reservation = Reservation.new(reservation_params)
    if @reservation.invalid?
      redirect_to edit_reservation_path, alert: '予約情報が不足しています'
    elsif @reservation.checkout_date <= @reservation.checkin_date
      redirect_to edit_reservation_path, alert: '過去と当日の日付は選択できません'
    elsif @reservation.guests.to_i <= 0
      redirect_to room_path(@reservation.room_id), alert: '人数には数字を入力してください'
    else
      count_totalprice_and_staydays
    end
  end
  
  def new
  end
  
  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to reservations_path
      flash[:notice] = "予約が完了しました。"
    end
  end
  
  def edit
    @reservations = Reservation.find(params[:id])
  end
  
  def update
    if @reservation.update(reservation_params)
      flash[:notice] = "保存しました。"
      redirect_to reservations_path
    else
      flash[:alert] = "問題が発生しました。"
      render :edit
    end
  end
  
  def destroy
    @reservations = Reservation.find(params[:id])
    @reservations.destroy
    flash[:notice] = "予約を削除しました"
    redirect_to reservations_path
  end
  
  private
    def reservation_params
      params.require(:reservation).permit(:checkin_date, :checkout_date, :stay_days, :guests, :total_price, :room_id, :user_id)
    end
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
    def count_totalprice_and_staydays
      start_date = Date.parse(reservation_params[:checkin_date])
      end_date = Date.parse(reservation_params[:checkout_date])
      days = (end_date - start_date).to_i
      @reservation.stay_days = days
      @reservation.total_price = @reservation.room.fee * @reservation.guests * days
    end
end
  