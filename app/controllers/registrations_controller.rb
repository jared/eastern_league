class RegistrationsController < ApplicationController
  before_filter :require_user

  def index
    load_event
    authorize! :update, @event
    @event_registrations = @event.event_registrations
  end

  def new
    load_event
    @event_registration = @event.event_registrations.build(:competitor => current_user.competitor)
    @user = @event_registration.competitor.user
  end

  def edit
    load_event
    @event_registration = @event.event_registrations.find(params[:id])
    @user = @event_registration.competitor.user
  end

  def update
    load_event
    @event_registration = @event.event_registrations.find(params[:id])
    @event_registration.registration_disciplines.clear

    params[:event_registration][:disciplines].each do |discipline_id|
      event_discipline = @event.event_disciplines.find_by_discipline_id(discipline_id)
      reg_disc = @event_registration.registration_disciplines.build(:event_discipline => event_discipline)
      case discipline_id.to_i
      when 13, 14, 15, 16
        reg_disc.group_name = params[:event_registration][:op_team_name]
        reg_disc.group_members = params[:event_registration][:op_team_members]
      when 17, 18, 19, 20, 21, 22
        reg_disc.group_name = params[:event_registration][:ot_team_name]
        reg_disc.group_members = params[:event_registration][:ot_team_members]
      when 23
        reg_disc.group_name = params[:event_registration][:ott_team_name]
        reg_disc.group_members = params[:event_registration][:ott_team_members]
      when 26, 27
        reg_disc.group_name = params[:event_registration][:omt_team_name]
        reg_disc.group_members = params[:event_registration][:omt_team_members]
      when 28, 29
        reg_disc.group_name = params[:event_registration][:omp_team_name]
        reg_disc.group_members = params[:event_registration][:omp_team_members]
      end
    end
    @event_registration.save
    redirect_to event_registrations_path(@event)
  end

  def create
    load_event

    @event_registration = @event.event_registrations.build({:competitor => current_user.competitor}.merge(params[:event_registration].slice(:volunteer_judge, :volunteer_field_staff, :volunteer_setup_crew, :first_time_competitor, :accepted_terms, :saturday_lunches, :sunday_lunches)))

    params[:event_registration][:disciplines].each do |discipline_id|
      event_discipline = @event.event_disciplines.find_by_discipline_id(discipline_id)
      reg_disc = @event_registration.registration_disciplines.build(:event_discipline => event_discipline)
      case discipline_id.to_i
      when 13, 14, 15, 16
        reg_disc.group_name = params[:event_registration][:op_team_name]
        reg_disc.group_members = params[:event_registration][:op_team_members]
      when 17, 18, 19, 20, 21, 22
        reg_disc.group_name = params[:event_registration][:ot_team_name]
        reg_disc.group_members = params[:event_registration][:ot_team_members]
      when 23
        reg_disc.group_name = params[:event_registration][:ott_team_name]
        reg_disc.group_members = params[:event_registration][:ott_team_members]
      when 26, 27
        reg_disc.group_name = params[:event_registration][:omt_team_name]
        reg_disc.group_members = params[:event_registration][:omt_team_members]
      when 28, 29
        reg_disc.group_name = params[:event_registration][:omp_team_name]
        reg_disc.group_members = params[:event_registration][:omp_team_members]
      end

    end

    tmp_amount = 0.0
    @flat_rate = nil

    case @event.acronym
    when "ODSKC"
      @flat_rate = 40.0
      @base_registration = 10.0
      @discipline_rate = 10.0
      @lunch_rate = 8
    when "OBSKC"
      # @flat_rate = 40.0
      @base_registration = 20.0
      @discipline_rate = 10.0
    when "FallFly"
      @flat_rate = 45.0
      @base_registration = 20.0
      @discipline_rate = 10.0
    when "ECSKC"
      @base_registration = 0.0
      @discipline_rate = 10.0
    when "MASKC"
      # @base_registration = 10.0
      @base_registration = 20.0
      @discipline_rate = 10.0
      # @flat_rate = 40.0
    when "TISKC"
      # @flat_rate = 45.0
      @base_registration = 20.0
      @discipline_rate = 20.0
    else
      @base_registration = 20.0
      @discipline_rate = 20.0
    end

    unless @event_registration.first_time_competitor?
      tmp_amount += @base_registration # Base registration
      @event_registration.registration_disciplines.each do |rd|
        tmp_amount += @discipline_rate # X dollars per discipline
      end
    end

    # Test against early, flat-rate fee
    if @flat_rate
      @event_registration.amount = (tmp_amount > @flat_rate) ? @flat_rate : tmp_amount
    else
      @event_registration.amount = tmp_amount
    end

    if @event.acronym == "ODSKC"
      @event_registration.amount += @lunch_rate * @event_registration.saturday_lunches
      @event_registration.amount += @lunch_rate * @event_registration.sunday_lunches
    end

    if @event_registration.save
      if @event_registration.amount > 0
        # Build Order
        @order = current_user.orders.build(:description => "#{@event.acronym} Registration for #{current_user.full_name}")
        @order.line_items.build(:purchasable => @event_registration, :amount => @event_registration.amount, :description => "#{@event.acronym} Registration for #{current_user.full_name}")

        @order.save
        flash[:notice] = "Your registration for #{@event.acronym} has been created."
        redirect_to purchase_user_order_path(current_user, @order) and return
      else
        flash[:notice] = "Your registration for #{@event.acronym} has been created.  As a first-time competitor, you do not need to pay a registration fee."
        redirect_to event_path(@event) and return
      end
    else
      @user = @event_registration.competitor.user
      flash[:error] = "Something went wrong, please try your registration again"
      render :action => :new
    end

  end


  def destroy
    load_event
    @event_registration = @event.event_registrations.find(params[:id])
    authorize! :destroy, @event_registration
    if @event_registration.destroy
      flash[:notice] = "You have removed this registration."
    else
      flash[:warning] = "Something went wrong.  Sorry"
    end
    redirect_to event_registrations_path(@event)
  end

private

  def load_event
    @event = Event.find(params[:event_id])
  end

end
