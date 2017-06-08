module ApplicationHelper

  def active?(path)
		"active-nav" if current_page?(path)
	end

  def flash_class(key)
    case key
      when "success" then "alert-success"
      when "info" then "alert-info"
      when "warning" then "alert-warning"
      when "notice" then "alert-warning"
      when "alert" then "alert-warning"
      when "danger" then "alert-danger"
      when "error" then "alert-danger"
    end
  end

  def amount_in_currency(amount_in_cents)
    number_to_currency(amount_in_cents/100)
  end

  # def markdown_to_html(text)
  #   Markdown.new(text).to_html.html_safe
  # end
  def markdown_to_html(markdown)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, prettify: true)
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    (redcarpet.render markdown).html_safe
  end


end
