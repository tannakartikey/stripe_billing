# README

## Seed

`rake db:seed` creates the plans on Stripe creates Plans on database as well as on Stripe if they are not already created.

## Login

Login functionality is very basic and just for demo purpose only. It has been created to give idea about various user status and permissions. It is not to be used in the production envrionment.

There is a `/users` path created to make the testing easy. It shows the various fields about the current users. Also, it gives one click login functionality. So that while testing the functionality there is no need to signin by username and password every time.

## User Parameters

Users table has various flags which determines the status of the user. They are as described below:

 - `is_active`:
This flag decided if user can use the pro content or not. Whenever user is not supposed to use pro features any more, this flag is set to false i.e. if a user's subscription is deleted or after they trial is over if user has not updated card details, this flag is set to false.

 - `charge_failed`:
If the charge is failed, the app might want to restrict user from certain actions. Currently, it does not let user visit `only_pro` content if the flag is set to true. If the falg is set to `false`, user is not restricted.

There is a functionality to repay the last failed charge. If the user repays successfully, this flag will set to `true` and user will be free to use pro content if other flags allowed.

 - `allowed_trial`:  
If a user subscribes to any paid plan, cancels it, and after few days again subscribes then they should not be able to go on trial again. `allowed_trial` keeps track on users' trial elligibility. If set to `false` user's subscription will be created without trial.

## Pages

### Only Pro

This path is accessible only to users subscribed to `Pro` plan. If any user is on free plan or if user have failed charge then user will not be able to go through this content.

### My Account

This page shows the current status of the subscription, as well as provides opton to cancel the subscription and reactivate it before it gets deleted.

### Card

This page displays the current payment source added by the user, if any. Or, it can be used to update the current payment source.

### Plan

This page shows the current plan as well as provides the optoins to change the plan.

The currently subscribed plan or Free plan will not be visible in the list.
User can fall back to `free` plan anytime by cancelling the subscription from `/my_account` path.

### Invoices

This page shows upcoming invoice, as well as all the invoices of the customer. `Status` shows if the invoice has been paid or not.

### Charges

This page shows the list of all the extra charges for the logged in user.

### Create Charge

This page is to demonstrate the creation of extra charge. The user will be charged as per the details enter in this form. Then Charge details will appear on the `/charge` path for that particular user. 

### Users

Shows the list of current users in the database as well as various fields for testing purpose.