require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LikesHelper. For example:
#
# describe LikesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LikesHelper, type: :helper do
  describe "#like_button_params" do
    let!(:current_user) { create(:user) }
    let!(:post) { create(:post) }

    it "should return hash with keys color and like_action" do
      params = like_button_params post
      expect(params.has_key? :color).to be true
      expect(params.has_key? :like_action).to be true
    end
    
    context "when micropost is liked" do

      before do
        current_user.like post
      end
      let!(:params) { like_button_params post}
      
      it "should have color red" do
        expect(params[:color]).to eq "red"
      end
      
      it "should have like_action to eq unlike for unlike link" do
        expect(params[:like_action]).to eq "unlike"
      end
      
    end
    
    context "when micropost is not liked" do

      let!(:params) { like_button_params post }

      it "should have color gray" do
        expect(params[:color]).to eq "gray"
      end

      it "should have like_action eq like for like link" do
        expect(params[:like_action]).to eq "like"
      end

    end

  end
end
