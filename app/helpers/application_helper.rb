module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, "#", onclick: "add_fields(this, '#{association}', '#{escape_javascript(fields)}');return false;", class: "add_fields_link" )
  end

  def title(title_text)
    content_for :page_title, raw("#{title_text} &raquo; Eastern League Sport Kite Association")
    content_for :title, title_text
  end

end
