require 'rails_helper'

RSpec.describe Micropost, type: :model do
  context "when create" do
    let(:user) {create(:user)}
    let(:micropost) { build(:micropost)}
    it "context should not be blank" do
      micropost.content = ""
      expect(micropost).not_to be_valid
    end

    it "user_id should not be blank" do
      micropost.user_id = nil
      expect(micropost).not_to be_valid
    end
  end
end
