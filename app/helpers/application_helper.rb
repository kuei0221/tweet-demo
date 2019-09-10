module ApplicationHelper

  def full_title(page_title)
    default = "tweet-demo"
    if page_title.present?
      "#{default}: #{page_title}"
    else
      default
    end
  end

  def dropdown_header
    if login?
      render "layouts/header_login"
    else
      render "layouts/header_not_login"
    end
  end

  def show_flash
    if flash.any?
      flash.each do |type, msg|
        concat content_tag(:div, msg, class: "alert alert-#{type}" )
      end
    end
  end

  def show_errors object
    if object.errors.any?
      content_tag :ul, class: "list-unstyled" do
        concat content_tag(:p, "#{object.errors.full_messages.size} errors occurred", class: "alert alert-warning")
        object.errors.full_messages.each do |error|
           concat content_tag(:li, error, class: "alert alert-warning")
        end
      end
    end
  end

end

# <% if object.errors.any? %>
# <ul>
#   <p class="alert alert-warning list-unstyles">
#     <%= object.errors.full_messages.count %> error occurred.
#   </p>
#   <% object.errors.full_messages.each do |error| %>
#     <li class="alert alert-warning list-unstyled"> ．<%= error %></li>
#   <% end %>
# </ul>
# <% end %>
