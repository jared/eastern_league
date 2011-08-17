module ApplicationHelper

  def title(title_text)
    content_for :page_title, raw("#{title_text} &raquo; Eastern Leage Sport Kite Association")
    content_for :title, title_text
  end

end
