class WildwoodRegistrationsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def index
    unless params[:auth] == "939188"
      flash[:error] = "You do not have authorization to view this page"
      redirect_to root_path and return
    end
    @season = Season.current
    @wildwood_registrations = WildwoodRegistration.where(:season_id => @season.id).order("created_at ASC")
  end

  def new

    flash[:error] = "ECSKC competition has been canceled for 2016."
    redirect_to "/" and return

    @season = Season.current
    @event = @season.events.find_by_acronym("ECSKC")
    @wildwood_registration = WildwoodRegistration.prepare(current_user)
  end

  def create
    @season = Season.current
    @event = @season.events.find_by_acronym("ECSKC")

    # create the registration
    @wildwood_registration = WildwoodRegistration.new(wildwood_registration_params)

    unless params[:humint].to_s.downcase =~ /kites/
      flash[:error] = "Please fill in the field below your email address as instructed to proceed."
      render :action => :new and return
    end

    if @wildwood_registration.save
      # send confirmation email
      UserMailer.wildwood_registration(@wildwood_registration).deliver

      # display printable receipt/voucher for payment
      redirect_to receipt_wildwood_registration_path(@wildwood_registration) and return
    else
      render :action => :new
    end
  end

  def destroy
    if current_user.admin?
      @wildwood_registration = WildwoodRegistration.find(params[:id])
      @wildwood_registration.destroy
      flash[:notice] = "Wildwood Registration has been deleted"
    end
    redirect_to wildwood_registrations_path(:auth => "939188")
  end

  def receipt
    @season = Season.current
    @event = @season.events.find_by_acronym("ECSKC")
    @wildwood_registration = WildwoodRegistration.find(params[:id])
  end

private 

  def wildwood_registration_params
    params.require(:wildwood_registration).permit!
  end

end
