require 'rails_helper'

RSpec.describe Relationship, type: :model do
  context "when create new relationship" do
    let(:user1) { create(:user)}
    let(:user2) { create(:user)}
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
end
