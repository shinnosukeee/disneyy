class ReservationRequestsController < ApplicationController
  def new
    @reservation = ReservationRequest.new
  end

  def create

    @reservation = ReservationRequest.new(reservation_params)


    user_email = params[:reservation_request][:user_email]
    @reservation.user = User.find_or_create_by(email: user_email)

    if @reservation.save

      ReservationMailer.confirmation_email(@reservation.user, @reservation).deliver_later


      CheckReservationJob.set(wait: @reservation.check_interval.minutes).perform_later(@reservation.id)

      redirect_to @reservation, notice: '予約リクエストが正常に登録されました。'
    else
      render :new
    end
  end

  def show
    @reservation = ReservationRequest.find(params[:id])
  end

  private

  # reservation_paramsから:user_emailを削除しました。
  def reservation_params
    params.require(:reservation_request).permit(:restaurant_id, :date, :party_size, :check_interval)
  end
end
