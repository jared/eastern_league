class WildwoodRegistrationsController < ApplicationController

  def index
    unless params[:auth] == "939188"
      flash[:error] = "You do not have authorization to view this page"
      redirect_to root_path and return
    end
    @season = Season.current
    @wildwood_registrations = WildwoodRegistration.where(:season_id => @season.id).order("created_at ASC")
  end

  def new
    @season = Season.current
    @event = @season.events.find_by_acronym("ECSKC")
    @wildwood_registration = WildwoodRegistration.prepare(current_user)
  end

  def create
    @season = Season.current
    @event = @season.events.find_by_acronym("ECSKC")

    # create the registration
    @wildwood_registration = WildwoodRegistration.new(params[:wildwood_registration])

    if @wildwood_registration.save
      # send confirmation email
      UserMailer.wildwood_registration(@wildwood_registration).deliver

      # display printable receipt/voucher for payment
      redirect_to receipt_wildwood_registration_path(@wildwood_registration) and return
    else
      render :action => :new
    end
  end

  def receipt
    @season = Season.current
    @event = @season.events.find_by_acronym("ECSKC")
    @wildwood_registration = WildwoodRegistration.find(params[:id])
  end


end
