class Help < ActiveRecord::Base

  def render_text
    "#{self[:text]}".html_safe
  end

end
