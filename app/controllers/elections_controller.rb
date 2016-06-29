class ElectionsController < ApplicationController
  before_filter :require_current_membership

  def index
    authorize! :create, Election
    @elections = Election.all
  end

  def show
    @election = Election.find(params[:id])
    @candidates = @election.candidates
    @vote = Vote.new
    if current_user.votes.any? { |v| v.election == @election }
      flash[:notice] = "You have already voted in this election."
      redirect_to root_url and return
    end
  end

  def new
    authorize! :create, Election
    @election = Election.new
  end

  def edit
    @election = Election.find params[:id]
    authorize! :edit, @election
  end

  def create
    authorize! :create, Election
    @election = Election.new(election_params)
    User.current.each { |u| @election.build_candidate(user_id: u.id) unless u.board_member? }
    if @election.save
      flash[:notice] = "Election created."
      redirect_to elections_path and return
    else
      render :action => :new
    end
  end

  def update
    @election = Election.find params[:id]
    authorize! :edit, @election
    if @election.save
      flash[:notice] = "Election updated."
      redirect_to elections_path and return
    else
      render action: :edit
    end
  end


  def results
    @election = Election.find(params[:id])
    authorize! :update, Election
  end

  def vote
    @election = Election.find(params[:id])

    if current_user.votes.any? { |v| v.election == @election }
      flash[:notice] = "You have already voted in this election."
      redirect_to root_url and return
    end

    @vote = @election.votes.build(params[:vote])
    if @vote.save
      flash[:notice] = "Your vote has been recorded.  Thank you!"
      redirect_to root_url and return
    else
      @candidates = @election.candidates
      render :action => :show
    end
  end

private

  def election_params
    params.require(:election).permit(:name, :description, :active, :close_at)
  end

end
