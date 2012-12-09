module RegistrationsHelper

  def team_name_and_members(discipline_group_name, event_registration = nil)
    class_prefix = discipline_group_name.downcase.gsub(/[^a-z]/, '_')
    output = ""
    case
    when discipline_group_name =~ /train/i
      output << content_tag(:label, "Team Name")
      output << content_tag(:input, "", :name => "event_registration[ott_team_name]", :type => "text", :class => "#{class_prefix}_team_name", :value => @event_registration.try(:ott_team_name))
      output << %{<div class="clear"><br /></div>}
      output << content_tag(:label, "Team Members")
      output << content_tag(:input, "", :name => "event_registration[ott_team_members]", :type => "text", :class => "#{class_prefix}_team_members", :value => @event_registration.try(:ott_team_members))
    when discipline_group_name =~ /team dual-line/i
      output << content_tag(:label, "Team Name")
      output << content_tag(:input, "", :name => "event_registration[ot_team_name]", :type => "text", :class => "#{class_prefix}_team_name", :value => @event_registration.try(:ot_team_name))
      output << %{<div class="clear"><br /></div>}
      output << content_tag(:label, "Team Members")
      output << content_tag(:input, "", :name => "event_registration[ot_team_members]", :type => "text", :class => "#{class_prefix}_team_members", :value => @event_registration.try(:ot_team_members))
    when discipline_group_name =~ /team multi-line/i
      output << content_tag(:label, "Team Name")
      output << content_tag(:input, "", :name => "event_registration[omt_team_name]", :type => "text", :class => "#{class_prefix}_team_name", :value => @event_registration.try(:omt_team_name))
      output << %{<div class="clear"><br /></div>}
      output << content_tag(:label, "Team Members")
      output << content_tag(:input, "", :name => "event_registration[omt_team_members]", :type => "text", :class => "#{class_prefix}_team_members", :value => @event_registration.try(:omt_team_members))
    when discipline_group_name =~ /pairs dual-line/i
      output << content_tag(:label, "Pair Name")
      output << content_tag(:input, "", :name => "event_registration[op_team_name]", :type => "text", :class => "#{class_prefix}_team_name", :value => @event_registration.try(:op_team_name))
      output << %{<div class="clear"><br /></div>}
      output << content_tag(:label, "Pair Members")
      output << content_tag(:input, "", :name => "event_registration[op_team_members]", :type => "text", :class => "#{class_prefix}_team_members", :value => @event_registration.try(:op_team_members))
    when discipline_group_name =~ /pairs multi-line/i
      output << content_tag(:label, "Pair Name")
      output << content_tag(:input, "", :name => "event_registration[omp_team_name]", :type => "text", :class => "#{class_prefix}_team_name", :value => @event_registration.try(:omp_team_name))
      output << %{<div class="clear"><br /></div>}
      output << content_tag(:label, "Pair Members")
      output << content_tag(:input, "", :name => "event_registration[omp_team_members]", :type => "text", :class => "#{class_prefix}_team_members", :value => @event_registration.try(:omp_team_members))
    end
    output << %{<div class="clear"><br /></div>}
    output
  end

end
