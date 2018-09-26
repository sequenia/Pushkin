# Pushkin
Pushkin sends push notifications to Android, iOS and Web clients through the unified simple interface using FCM.
You can also show Web Push Notifications using Pushkin implementation.

## Usage

### How to create notifications

```ruby
notification = Pushkin.simple_notification_to_users({
  notification_type: "poem",
  users: User.all,
  title: "Ruslan and Ludmila",
  body: "The story of the abduction of Ludmila, the daughter of Prince Vladimir of Kiev, by an evil wizard and the attempt by the brave knight Ruslan to find and rescue her"
})
```

It creates a push notification with static content to the specified users. Actual user tokens will be queried from the database at the time of sending.

Run this code to send notification immediately using ActiveJob:
```ruby
notification.send_now
```

You can also send notifications synchronously:
```ruby
notification.send_now(async: false)
```

### Creation parameters

| Parameter          | Usage                    | Description                                                        |
| ------------------ | ------------------------ | ------------------------------------------------------------------ |
| :notification_type | Required, String         | Custom string to distinguish notifications from each other         |
| :users             | Required, Array/Relation | List of users to send push notifications                           |
| :title             | Required, String         | Notification title                                                 |
| :body              | Optional, String         | Notification text                                                  |
| :click_action      | Optional, Hash           | Click actions of each platform                                     |
| :icon              | Optional, Hash           | Notification icon for web and android platforms                    |
| :is_data_message   | Optional, Hash           | Specifies if you want to send data message instead of notification |
| :data              | Optional, Hash           | Any notification data that will be sent in the notification        |

In any case, :data hash will include following parameters:

| Parameter               | Usage                | description                                  |
| ----------------------- | -------------------- | -------------------------------------------- |
| :notification_type      | Required, String     | Value of :notification_type parameter        |
| :notification_id        | Required, Integer    | Unique identifier of created notification    |

**:click_action hash keys**

| Parameter | Usage                | description                          |
| --------- | -------------------- | ------------------------------------ |
| :web      | Optional, String     | URL to open in the browser           |
| :ios      | Optional, String     | Category in the APNs payload         |
| :android  | Optional, String     | Intent filter to launch the Activity |

**:icon hash keys**

| key      | value type           | description                      |
| -------- | -------------------- | -------------------------------- |
| :web     | Optional, String     | Public absolute URL of icon      |
| :android | Optional, String     | Drawable resource name           |

**:is_data_message hash keys**

| key      | value type           | description                      |
| -------- | -------------------- | -------------------------------- |
| :web     | Optional, Boolean    | True, if you want to send data message to web client     |
| :ios     | Optional, Boolean    | True, if you want to send data message to ios client     |
| :android | Optional, Boolean    | True, if you want to send data message to android client | 

In case of data messages all notification attributes like title and body will be sent in data instead of notification.

## Gem Installation
Add this line to your application's Gemfile:

```ruby
gem 'pushkin-library'
```

And then execute:
```bash
$ bundle install
```

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

By default Pushkin uses FCM_SERVER_KEY environment variable for sending push notifications, but you can configure Pushkin yourself in config/application.rb:
```ruby
Pushkin.configure do |config|
  config.fcm_server_key = ENV["FCM_SERVER_KEY"]
end
```

If you want to attach device tokens to users, you need to implement authentication logic in *Pushkin::Api::V1::TokensController* and add this line to *User* model:
```ruby
include Pushkin::Concerns::PushkinUser
```

## Web Push Notifications Setup

Add JavaScript FCM Client App to your Rails App ([instructions](https://firebase.google.com/docs/cloud-messaging/js/client)) without permission request, token access and notifications showing. You just need to create FCM project in FCM console, link FCM libraries and put manifest file to public directory.

Add this lines to your layout file:
```erb
<script src="https://www.gstatic.com/firebasejs/5.4.1/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/5.4.1/firebase-messaging.js"></script>
<link rel="manifest" href="/manifest.json">
<%= javascript_include_tag "pushkin/application" %>
```

Init FCM messaging object in javascript code and save it to Pushkin:
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

Init notifications showing, access to token and permission request:
```javascript
PUSHKIN.initNotifications();
PUSHKIN.requestPermission();
```

**Attention!** If you want to show push notifications while browser is closed, you still needs to implement this logic in *firebase-messaging-sw.js* yourself.

## Tokens management API

**Request type:** POST

**Content type:** 'application/json'

**Request body:**
```json
{
  "push_token_info":{
    "platform":"android",
    "token":"123456",
    "old_token":"12345"
  }
}
```

| key       | value type           | description                                              |
| --------- | -------------------- | -------------------------------------------------------- |
| platform  | Required, String     | Platform type. Available values: "web", "android", "ios" |
| token     | Required, String     | The token for push notifications sending                 |
| old_token | Optional, String     | The old token value to deactivate if token refreshed     |

If you send the authentication data in this request, Pushkin will attach current user to token. Otherwise, Pushkin will destroy the user-token relation.

**Response body:**
```json
{
  "success":true,
  "info":"Done"
}

```

| key       | value type           | description                                              |
| --------- | -------------------- | -------------------------------------------------------- |
| success   | Required, Boolean    | True, if the request completed without any error         |
| info      | Required, String     | Short description of response / Error info               |

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
