# Pushkin
Pushkin can help you plan and send push notifications to Android, iOS and Web clients through unified simple interface using FCM.

## Usage
Execute in command line:
```bash
$ bin/rails generate pushkin:setup
```

It will generate:
* migration *CreatePushkinTables* to create tables for notifications sending.
* controller *Pushkin::Api::V1::TokensController* for managing device tokens.
* routes for tokens controller

And then run migration:
```bash
$ rake db:migrate
```

If you want to attach device tokens to users, you need to realize authentication logic in *Pushkin::Api::V1::TokensController* and add this line to *User* model:
```ruby
include Pushkin::Concerns::PushkinUser
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pushkin'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install pushkin
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
