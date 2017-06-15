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

  # moved to ApplicationController
  # def markdown_to_html(markdown)
  #   renderer = Redcarpet::Render::HTML.new(hard_wrap: true, prettify: true)
  #   extensions = {fenced_code_blocks: true}
  #   redcarpet = Redcarpet::Markdown.new(renderer, extensions)
  #   (redcarpet.render markdown).html_safe
  # end

  def all_wikis_count
    if current_user && current_user.admin?
      Wiki.count
    else
      Wiki.where(private: false).count +
      Wiki.where(private: true).where(user: current_user).count +
      Collaborator.where(user: current_user).count # wikis this user is collaborating with
    end
    #raise
  end

  def public_wikis_count
    Wiki.where(private: false).count
  end

  def private_wikis_count
    if current_user && current_user.admin?
      Wiki.where(private: true).count
    else
      Wiki.where(private: true).where(user: current_user).count +
      Collaborator.where(user: current_user).count
    end
  end


end
