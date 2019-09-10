require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user1) { create(:user)}
  let!(:user2) { create(:user)}
  context "when create new relationship" do
    it "should have both users' id " do
      relationship = user1.active_relationships.new(followed_id: user2.id)
      expect(relationship).to be_valid
    end
    
    it "should have followed_id" do
      relationship = user1.active_relationships.new(followed_id: "")
      expect(relationship).not_to be_valid
    end

    it "should have follower_id" do
      relationship = user2.passive_relationships.new(follower_id: "")
      expect(relationship).not_to be be_valid
    end
  end

  context "when following" do
    before :each do
      user1.follow user2
    end
    it "should create active relationsip" do
      expect(user1.active_relationships.find_by(followed_id: user2.id)).not_to be false
      expect(user1.following.include? user2).to be true
    end
    
    it "should create passive relationship" do
      expect(user2.passive_relationships.find_by(follower_id: user1.id)).not_to be false
      expect(user2.followers.include? user1).to be true
    end
    
    it "shoud get true for following?" do
      expect(user1.follow? user2).to be true
    end
  end
  
  context "when unfollow" do
    before :each do
      user1.follow user2
      user1.unfollow user2
    end
    
    it "should delete the relationship" do
      expect(user1.active_relationships.find_by(followed_id: user2.id)).to be nil
      expect(user2.passive_relationships.find_by(follower_id: user1.id)).to be nil
      expect(user1.follow? user2).to be false
    end

  end
  
end
