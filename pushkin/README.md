# Pushkin
Pushkin sends push notifications to Android, iOS and Web clients through unified simple interface using FCM.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pushkin-library'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install pushkin-library
```

## Usage
Execute in command line:
```bash
$ bin/rails generate pushkin:setup
```

It will generate:
* migration *CreatePushkinTables* to create tables for notifications sending.
* controller *Pushkin::Api::V1::TokensController* for managing device tokens.
* routes for tokens controller.

And then run migration:
```bash
$ rake db:migrate
```

Add the following to your environment variables:
```bash
PUSHKIN_API_KEY=ANY_API_KEY_FOR_REQUEST_AUTHORIZATION
FCM_SERVER_KEY=YOUR_FCM_SERVER_KEY_FROM_FCM_CONSOLE
```

If you want to attach device tokens to users, you need to implement authentication logic in *Pushkin::Api::V1::TokensController* and add this line to *User* model:
```ruby
include Pushkin::Concerns::PushkinUser
```

## Web Push Notifications Setup

If you don't want to implement push notifications showing in web browsers, you can use Pushkin implementation.

Add JavaScript Firebase Cloud Messaging Client App to your Rails App ([instructions](https://firebase.google.com/docs/cloud-messaging/js/client)) without permission request, token retreiving, token refresh monitoring and notification showing. Pushkin implements it for you.

Add this line to yout layout file:
```erb
<%= javascript_include_tag "pushkin/application" %>
```

Init FCM messaging object and save it to Pushkin:
```javascript
firebase.initializeApp(yourFirebaseSettings);
var messaging = firebase.messaging();
messaging.usePublicVapidKey(YOUR_PUBLIC_VAPID_KEY);
PUSHKIN.messaging = messaging;
```

Implement token sending:
```javascript
Pushkin.prototype.sendFirebaseTokenToServer = function (currentToken) {
  // Send currentToken to server using Pushkin API
}
```

Init notifications showing and permission request:
```javascript
PUSHKIN.initNotifications();
PUSHKIN.requestPermission();
```

**Attention!** If you want to show push notifications while browser is closed, you still needs to implement this logic in *firebase-messaging-sw.js* yourself.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
