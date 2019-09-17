require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "::create" do
    let!(:post) { create(:post) }
    let(:comment) { build(:comment, post_id: post.id) }

    context "with correct example" do
      it "should be valid with default example" do
        expect(comment).to be_valid
      end
  
      it "should have type: comment in micrpost model" do
        expect(comment.type).to eq("Comment")
      end
    end

    context "with post_id" do
      it "should belong to particular micropost" do
        comment = build(:comment, post_id: "")
        expect(comment).to be_invalid
      end
    end
    
    context "with user_id" do
      it "should belong to author (user)" do
        comment = build(:comment, user_id: "")
        expect(comment).to be_invalid
      end
    end

    context "with content" do
      it "should have content" do
        comment= build(:comment, content: "")
        expect(comment).to be_invalid
      end
      
      it "should not longer than 140 words" do
        comment = build(:comment, content: "a"*141)
        expect(comment).to be_invalid
      end
    end

    context "with likes_count" do
      it "should have likes counter" do
        expect(comment.likes_count).to be_present
      end
    end

  end
  context "untext traits" do

    it "should have user info" do
    end

    it "should order with time pass (asec)" do
    end

    it "should follow other comment in same post" do
    end


    it "should not have comment button" do
    end

  end
end