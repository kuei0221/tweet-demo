require "rails_helper"

RSpec.describe "Notification", type: :request do

  describe "#new" do
    let!(:user) { create(:user) }
    context "when building new connection to notification sys when logging" do
      # it "should return error is not login in json " do
      #   # login(user) 
      #   get "/notification", params: { token: "aa", format: :json }
      #   puts response.body
      #   expect(response.content_type).to eq("application/json")
      # end

      it "" do
        login(user)
        expect(is_logged_in?).to be true
      end


    end
  end
end