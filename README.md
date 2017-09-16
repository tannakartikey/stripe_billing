# README

## Seed

`rake db:seed` creates the plans on Stripe creates Plans on database as well as on Stripe if they are not already created.

## Login

Login functionality is very basic and just for demo purpose only. It has been created to give idea about various user status and permissions. It is not to be used in the production envrionment.

There is a `/users` path created to make the testing easy. It shows the various fields about the current users. Also, it gives one click login functionality. So that while testing the functionality there is no need to signin by username and password every time.

## Only Pro Content

There is an `/only_pro` path which should be accessible only to users with paid subscription. If any user is on free plan or if user have failed charge then user will not be able to go through this content.

## User Parameters

Users table has various flags which determines the status of the user. They are as described below:

 - `is_active`:  
This flag decided if user can use the pro content or not. Whenever user is not supposed to use pro features any more, this flag is set to false i.e. if a user's subscription is deleted or after they trial is over if user has not updated card details, this flag is set to false. 

 - `charge_failed`:  
If the charge is failed, the app might want to restrict user from certain actions. Currently, it does not let user visit `only_pro` content if the flag is set to true. If the falg is set to `false`, user is not restricted. 

There is a functionality to repay the last failed charge. If the user repays successfully, this flag will set to `true` and user will be free to use pro content if other flags allowed.

 - `allowed_trial`:  
If a user subscribes to any paid plan, cancels it, and after few days again subscribes then they should not be able to go on trial again. `allowed_trial` keeps track on users' trial elligibility. If set to `false` user's subscription will be created without trial.

## Plan Change

User can change their plan anytime from `plans` path. The currently subscribed plan or Free plan will not be visible in the list.
User can fall back to `free` plan anytime by cancelling the subscription from `my_account`.
