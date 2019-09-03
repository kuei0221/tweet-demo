module ApplicationHelper
  def full_title(page_title)
    default = "tweet-demo"
    if page_title.present?
      "#{default}: #{page_title}"
    else
      default
    end
  end
end
