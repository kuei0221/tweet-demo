# Tweet Demo

This is a Tweet initmating project, mainly representing my studying path of Ruby on Rails.

The project start with building member system manually by following instruction of the book: Ruby on Rail Tutorial written by Michael Hartl, which also include account activating and password reseting with mailer sending, creating new post and uploading avatar image. It also includes the following and follower system which allows members to get the feed from their folloing users.

After the tutorial, I have refactored the code and extracted some function into form object and service object. And then start to build the core function of tweet's post: "comment", "retweet" and "like". These functions are also presented with ajax to increase the user experience.

Since there are multiple pages loading collection of date, cache system is added in most collecting pages with pragement cache to increase the efficiency.

The project has been covered with multiple unit tests building with Rspec and Factory-bot.

