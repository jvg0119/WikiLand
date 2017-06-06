module ApplicationHelper

  def active?(path)
		"active" if current_page?(path)
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

end



# flash_class(key)
# alert-success
