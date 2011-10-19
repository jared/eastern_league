module EventsHelper
  
  def status_name_and_link(event)
    case event.status
    when "Results Available"
      link_to event.status, event_path(event)
    else
      event.status
    end
  end
  
end
