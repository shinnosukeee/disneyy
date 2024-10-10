class ReservationMailer < ApplicationMailer
  default from: 'shinhapi1111@gmail.com'

  def confirmation_email(user, reservation)
    @user = user
    @reservation = reservation
    mail(to: @user.email, subject: '予約確認')
  end


  def availability_notification(user, reservation)
    @user = user
    @reservation = reservation
    mail(to: @user.email, subject: '予約キャンセル通知')
  end
end
