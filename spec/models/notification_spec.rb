require "rails_helper"

RSpec.describe Notification, type: :model do

  
  let!(:user) { create(:user) }
  let!(:feeder) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }
  describe "::create" do
    let(:notification) { build(:notification, user: user, micropost: micropost, feeder: feeder.name, action: "valid_action") } 
    it "should be valid with correct data" do
      expect(notification.save).to be true
      expect(user.microposts.include?(micropost)).to be true
      expect(user.notifications.include?(notification)).to be true
    end
    
    it "should be new when create" do
      notification.save
      expect(notification.new).to be true
    end
    
    context "with empty user " do
      it "should be invalid" do
        notification = build(:notification, user: nil)
        expect(notification).to be_invalid
      end
    end
    
    context "with empty micropost " do
      it "should be false when saving with empty micropost" do
        notification = build(:notification, micropost: nil)
        expect(notification).to be_invalid
      end
    end
    
    context "with empty action" do
      it "should be invalid" do 
        notification = build(:notification, action: nil)
        expect(notification).to be_invalid
      end
    end
    
    context "with empty feeder" do
      it "should be invalid" do
        notification = build(:notification, feeder: nil)
        expect(notification).to be_invalid
      end
    end
  end
  
  describe "::desc_time_order" do
    let!(:other_micropost) { create(:micropost, user: user) }
    let!(:notification) { create(:notification, user: user, micropost: micropost, feeder: feeder.name, action: "valid_action") } 
    it "should order notification with newest comes first" do
      latest_notification = create(:notification, user: user, micropost: other_micropost, feeder: feeder.name, action: "valid_action")
      expect(Notification.desc_time_order.first).to eq latest_notification
      expect(Notification.desc_time_order.second).to eq notification
    end
  end
  
  describe "::read" do
    let!(:notification) { create(:notification, user: user, micropost: micropost, feeder: feeder.name, action: "valid_action") } 
    it "should read the unread notification" do
      expect(notification.new).to be true
      Notification.read
      expect(notification.reload.new).to be false
    end
  end
  
  describe "::scope" do
    
    before do
      create_list(:notification, 5, user: user, micropost: micropost, feeder: feeder.name, action: "valid_action")
    end
    
    context "unread" do
      it "should select unread notification" do
        expect(Notification.all.unread.size).to eq(5)
      end
    end
    
    context "history" do
      it "should only select notification before given id" do
        expect(Notification.history(Notification.second.id)).to include(Notification.first)
      end
    end
    
  end
  
  describe "#message" do
    let!(:notification) { create(:notification, user: user, micropost: micropost, feeder: feeder.name, action: "valid_action") } 
    it "should generate message " do
      expect(notification.message).to eq("#{notification.feeder} has #{notification.action} your post: #{notification.micropost.content[0..25]}")
    end
  end
end