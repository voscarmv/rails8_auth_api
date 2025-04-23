# Rails 8 Auth API example

## Guides used

- https://a-chacon.com/en/on%20rails/2024/10/16/poc-using-rails-8-auth-system-in-api-only.html
- https://medium.com/craft-academy/authentication-in-rails-8-api-only-application-ac33234b74de

## Postman requests

- https://team55-6229.postman.co/workspace/722dec53-df85-40a5-8244-4a7f428b1a8c/request/17376401-d068842a-992c-4626-9515-6a3ba888950a?action=share&source=copy-link&creator=17376401&ctx=documentation

## Created with

```
$ rails new my_api_app --api
$ cd my_api_app
$ rails g authentication
$ rails g scaffold project title:string description:text user:references
```

## Installation and testing

Clone, `cd` into the dir and run

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ rails s
```

And test with the API calls from [Rails 8 Auth Tester](https://github.com/voscarmv/rails_8_auth_tester2).

In the tester, run

```
$ npm install
$ node changepass.js
```

To change your admin password. The default username: `admin@example.com` and password: `admin`.

Use `node adminsignup.js` to create a new user account.

The only difference between admin role and user role currently is that admin can create, delete and update users and other admins, but user can not. You may add as many roles and permissions as you need.

To change your password you will need to provide your actual email, as the API will mail you a reset token. Also, for that to work you'll have to set up your own SMTP credentials directly in `config/environments/development.rb` or using the encrypted environment with something like `EDITOR=nano rails credentials:edit --environment=development`

Remember to `rails db:rollback` if `rails db:migrate` don't work
