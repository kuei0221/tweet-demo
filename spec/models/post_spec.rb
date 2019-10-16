require "rails_helper"
require "pusher"

RSpec.describe Post, type: :models do
  describe "::create" do
    let!(:user) { create(:user) }
    let(:post) { build(:post, user_id: user.id) }

    context "with correct example" do
      it "should be valid" do
        expect(post).to be_valid
      end

      it "should have type: Post" do
        expect(post.type).to eq "Post"
      end
    end
    
    context "with user_id" do
      it "should exist" do
        post = build(:post, user_id: "")
        expect(post).to be_invalid
      end
    end

    context "with content" do
      it "should exist" do
        post = build(:post, content: "")
        expect(post).to be_invalid
      end

      it "should no longer than 140 words" do
        post = build(:post, content: "a" *141)
        expect(post).to be_invalid
      end
    end

    context "with comments" do
      let!(:post_with_comments) { create(:post_with_comments) }
      it "should have comments" do
        expect(post_with_comments.comments).to be_present
      end

      it "should have comments_count which matched" do
        expect(post_with_comments.comments_count).to eq post_with_comments.comments.size
      end

      it "should have time asc orderd comments" do
        expect(post_with_comments.comments.first.updated_at).to be < post_with_comments.comments.last.updated_at
      end
    end

    context "with likes" do
      before :each do
        @my_post = create(:post, user_id: user.id)
        5.times do
          create(:user).like @my_post
        end
        @my_post.reload
      end
      it "should have likes" do
        expect(@my_post.likes).to be_present
      end

      it "should have liked_users" do
        expect(@my_post.liked_users).to be_present
      end

      it "should have likes_count which matched" do
        expect(@my_post.likes_count).to eq @my_post.liked_users.size
        expect {user.like @my_post}.to change { @my_post.reload.likes_count}.by 1
      end
    end
  end
end