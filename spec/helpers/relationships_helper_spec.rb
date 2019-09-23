require 'rails_helper'
include SessionsHelper

RSpec.describe RelationshipsHelper, type: :helper do
  let!(:user) { create(:user) }
  let(:current_user) { create(:user) }

  describe "#is_passive_relationship?" do
    it "should be true if it is followers page" do
      @relationship = :followers
      expect(is_passive_relationship? @relationship).to be true
    end
  end

  describe "#follow_button_path" do
    it  "should be follow button by default" do
      expect(follow_button_path user).to eq "users/follow"
    end
    it "should be unfollow button if user is followed" do
      current_user.follow user
      expect(follow_button_path user).to eq "users/unfollow"
    end
  end

  describe "#check_follow_button" do

    it "should return nil if the user is yourself" do
      user = current_user
      expect(user).to eq(current_user)
      expect(current_user? user).to be true
      expect(!login?).to be false
      expect(check_follow_button user).to be false
    end

    it "should return nil if you are looking at your followers list" do
      @relationship = :followers
      params[:id] = current_user.id.to_s
      expect(check_follow_button user).to be false
    end
    
    it "should not retunr nil if you are looking at other followers list" do
      @relationship = :followers
      params[:id] = 100000
      expect(params[:id]).not_to eq(current_user.id.to_s)
      expect(check_follow_button user).not_to be false
    end

    it "should not retunr nil if you are looking at other following list" do
      @relationship = :following
      params[:id] = 100000
      expect(params[:id]).not_to eq(current_user.id.to_s)
      expect(check_follow_button user).not_to be false
    end
    
    it "should return nil if you are looking at yourself at others followers list" do
      @relationship = :followers
      user = current_user
      expect(check_follow_button user).to be false
    end
    
    it "should return nil if you are looking at yourself at others following list" do
      @relationship = :following
      user = current_user
      expect(check_follow_button user).to be false
    end

    it "should return follow button if you are looking at unfollow member" do
      expect(check_follow_button user).to be true
    end
    
    it "should return unfollow button if you are looking at follow member" do
      current_user.follow user
      expect(check_follow_button user).to be true
    end

  end

  describe "#follow_button_html" do
  end

end
