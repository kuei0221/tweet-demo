# Tweet Demo
[![Build Status](https://travis-ci.org/kuei0221/tweet-demo.svg?branch=master)](https://travis-ci.org/kuei0221/tweet-demo)

This is a Twitter website mocking project, focusing on rebuilding the commonlu used function in the social website.

The project is started by following the instruction of the book: Ruby on Rail Tutorial written by Michael Hartl, and then implementing various external service to fulfill the completence.

Now it is published [here.](https://mytweet-demo.herokuapp.com/)

This project is only for academic research, not for any commerical usage.

## Features:
* Manually built user system based on the understanding of session and cookies.
* Mailing is allowed through Mailgun service when user authorizing and password reset.
* User is enabled to create their post, and also can like, share and comment on the post. The link of the post is also provided.
* User can follow other users to get other users' post in their home page.
* User can upload their own avatar when creating account or uploading. If no avatar when creating, attaching default avatar instead.
* Allow login through Facebook or Google account with oauth2 authenticating process.
- **Notification system build with Pusher**
  - Realtime notifnication push when other user does action on their post. (currently just like)
  - Showing how much unread notification, and clear the counting once read.
  - Can view through their own notification history.
 
## Environment
* Rails 5.2.3
* Ruby 2.6.3
* RVM 1.29.9
* Ubuntu 18.04.3 LTS under Win10
- **Service**
  - [Heroku](https://www.heroku.com/) for deloyment
  - [postgresql](https://www.postgresql.org/) as database
  - [Facebook](https://developers.facebook.com/) and [Google](https://developers.google.com/identity/choose-auth) for oauth2 login
  - [Amazon s3](https://aws.amazon.com/tw/s3/) as image storage
  - [Mailgun](https://www.mailgun.com/) for mailing
  - [Pusher](https://pusher.com/) for notification
  - [Travis-ci](https://enterprise.travis-ci.com/) for CI 
  - [git](https://github.com/) for version control
  - [privacypolicies](https://www.privacypolicies.com) for privacy
  
### Notice
* Most service has required vertified account and its api key which is not shown here.

## Contact
Created by Chien-Wei Huang (Michael)

Email: michaelhwang0619@gmail.com
