class AnnualEventsController < ApplicationController

  def index
    @annual_events = AnnualEvent.order(:event_name)
  end

end
