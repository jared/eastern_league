module EventsHelper
  
  def status_name_and_link(event)
    case event.status
    when "Results Available"
      link_to event.status, event_path(event)
    else
      event.status
    end
  end
  
  def score_name_and_link(score)
    if score.competitor.pair? || score.competitor.team?
      score.competitor.name
    else
      link_to score.competitor.name, user_path(score.competitor.user)
    end
  end
  
  def event_detail_links(event_detail)
    output = []
    sections = %w(competitor_information schedule directions accommodations banquet auction sponsors)
    sections.each do |section|
      link = content_tag(:li) do
        content_tag(:a, section.humanize.titleize, :href => "##{section}")
      end
      output << link unless event_detail.send(section.to_sym).blank?
    end
    output.join("\n")
  end
  
end
