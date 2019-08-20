module ApplicationHelper
  def full_title(page_title)
    default = "tweet-demo"
    unless page_title.nil?
      "#{default}: #{page_title}"
    else
      default
    end
  end
end
