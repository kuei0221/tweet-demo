require 'rails_helper'

RSpec.describe Micropost, type: :model do
  context "when create" do
    let(:user) {create(:user)}
    let(:micropost) { build(:micropost)}
    it "context should not be blank" do
      micropost.content = ""
      micropost.save
      expect(micropost.valid?).to eq(false)
    end

    it "user_id should not be blank" do
      micropost.user_id = nil
      micropost.save
      expect(micropost.valid?).to eq(false)
    end

    it "should increase the number of post" do
      expect{ micropost.save}.to change {user.microposts.count}.by(1)
    end
  end
end
