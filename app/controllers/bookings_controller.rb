class BookingsController < ApplicationController
  before_action :authenticate_user!
  def new
    @booking = Booking.new
    # @booking.user = current_user
  end
# To display all the bookings
  def show
  	@booking = Booking.all
  end
# to create new booking
  def create
  	@booking = Booking.new(booking_params)
    raise "Not allowed to make more than 1 booking" unless @booking.user.can_book_rooms?
    @booking.save
    session[:booking_id] = @booking.id
    UserMailer.notification_email(@booking.user).deliver_now
    flash[:notice]='Booking created. Admin will review the request.'
    redirect_to ("/invite/")
  end

  def invite

  end
# to invite members for the booking
  def invite_send
    @booking = Booking.find(session[:booking_id])
    params.permit(:emails)
    list_of_email = params[:emails].gsub(/\s+/, "").split(',')
    # list_of_emails -- Iterate over this. and send emails.
    # @booking has the concernded booking
    # CHANGE THE NEXT LINE.
    list_of_email.each do |email|
      UserMailer.invite_email(email, @booking).deliver_now
    end
    flash[:notice]='Emails sent'
    redirect_to "/"
  end

  def booking_params
  	puts params.inspect
    params.require(:booking).permit(:user_id,:room_id,:start_time)
  end
# to delete the booking
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to '/'
  end
end
