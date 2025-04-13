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

## Run with

`$ rails s`

And test with postman

Remember to `rails db:rollback` if `rails db:migrate` don't work