require "rails_helper"
# require "features/features_helper"

RSpec.feature "create new post", type: :feature do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  scenario "create new post" do

    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"

    fill_in placeholder: "New Post", with: ""
    click_button "Create new post"
    expect(page).to have_text "Invalid"
    expect(page).to have_current_path root_url

    fill_in placeholder: "New Post", with: "Some content"
    click_button "Create new post"
    expect(page).to have_text "success"
    expect(page).to have_current_path root_url
    expect(page).to have_text "Some content"

    visit user_path(other_user.id)
    expect(page).not_to have_button "Create new post"

  end
end
