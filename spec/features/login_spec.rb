require "rails_helper"

RSpec.feature "login", type: :feature do

  # background do
  # end
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  scenario "when login with valid info" do
    visit login_path
    expect(page).to have_current_path login_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    expect(page).to have_text "success"
    expect(page).to have_link "Logout"

    click_link "Profile"
    expect(page).to have_current_path user_path user

    fill_in "Password", with: "aaaaaaaaaa"
    click_button "Update Information"
    expect(page).to have_text "fail"

    fill_in "Password confirmation", with: "aaaaaaaaaaa"
    click_button "Update Information"
    expect(page).to have_text "fail"

    fill_in "Name", with: "new_name"
    click_button "Update Information"
    expect(page).to have_text "success"
    expect(page).to have_current_path user_path user
    

    click_link "Users"
    expect(page).to have_current_path users_path

    visit user_path(other_user.id)
    expect(page).to have_current_path user_path(other_user.id)

    click_link "Edit"
    expect(page).to have_current_path root_url

    click_link "Logout"
    expect(page).to have_current_path root_url
    expect(page).to have_text "success"
    
  end 

  scenario "when login with invalid info" do
    visit login_path
    expect(page).to have_current_path login_path

    fill_in "Email", with: " "
    fill_in "Password", with: " "
    click_button "Login"
    expect(page).to have_text "fail"
    expect(page).not_to have_link "Logout"

    visit user_path(user.id)
    expect(page).to have_current_path login_path

    visit edit_user_path(user.id)
    expect(page).to have_current_path login_path

  end
end