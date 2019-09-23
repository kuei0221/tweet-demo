require "rails_helper"
require "features/features_helper"
include FeaturesHelper

RSpec.feature "create new post", type: :feature do
  let!(:user) { create(:user_with_posts) }
  let!(:other_user) { create(:user_with_posts) }
  scenario "create new post" do

    login_process user
  
    fill_in placeholder: "New Post", with: ""
    click_button "Create new post"
    expect(page).to have_text "Invalid"
    expect(page).to have_current_path root_url

    fill_in placeholder: "New Post", with: "Some content"
    click_button "Create new post"
    expect(page).to have_text "success"
    expect(page).to have_current_path root_url
    expect(page).to have_text "Some content"

    expect(page).to have_css "#like_button #like-icon"
    expect(page).to have_css "#share_form #share-icon"
    expect(page).to have_css "#comment_form #comment-icon"

    within "#post-#{user.posts.first.id}" do
      expect(page).to have_css "#like_button #like-icon"
      expect(user.posts.first.likes_count).to eq(0)
      expect(page).to have_css "#share_form #share-icon"
      expect(user.posts.first.comments_count).to eq(0)
      expect(page).to have_css "#comment_form #comment-icon"
      expect(user.posts.first.shares_count).to eq(0)

      find("#like_button a").click
      # expect(user.posts.first.reload.likes_count).to eq(1)
      expect(page).to have_current_path root_url
      
      # find("#comment_form a").click
      fill_in placeholder: "Comment:", with: "Some Comment\n"
      # expect(page.find("#comment_form div")).to have_content "1"
      expect(page).to have_current_path root_url
      
      # find("#share_form a").click
      fill_in placeholder: "Share:", with: "Some Share\n"
      # expect(user.posts.first.reload.shares_count).to eq(1)
      expect(page).to have_current_path root_url

    end

    visit user_path(other_user.id)
    expect(page).not_to have_button "Create new post"

    within "#post-#{other_user.posts.first.id}" do
      find("#like_button #like-icon").click
      expect(page).to have_current_path user_path(other_user.id)
      
      find("#comment_form #comment-icon").click
      fill_in placeholder: "Comment:", with: "Some Comment\n"
      expect(page).to have_current_path user_path(other_user.id)
      
      find("#share_form #share-icon").click
      fill_in placeholder: "Share:", with: "Some Share\n"
      expect(page).to have_current_path user_path(other_user.id)

    end

  end
end
