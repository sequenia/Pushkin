# Pushkin
Pushkin sends push notifications to Android, iOS and Web clients through unified simple interface using FCM.

## Usage

### How to create notifications

```ruby
notification = Pushkin::NotificationFabric.new.simple_notification_to_users({
  notification_type: "poem",
  users: User.all,
  title: "Ruslan and Ludmila",
  body: "The story of the abduction of Ludmila, the daughter of Prince Vladimir of Kiev, by an evil wizard and the attempt by the brave knight Ruslan to find and rescue her"
})
```

It creates push notification with static content to specified users. Actual user tokens will be retrieved from database at the time of sending.

### Creation parameters

| Parameter          | Usage                    | Description                                                 |
| ------------------ | ------------------------ | ----------------------------------------------------------- |
| :notification_type | Required, String         | Custom string to  distinguish notifications from each other |
| :users             | Required, Array/Relation | List of users to send push notifications                    |
| :title             | Required, String         | Notification title                                          |
| :body              | Optional, String         | Text of notification                                        |
| :click_action      | Optional, Hash           | Click actions for each platform                             |
| :icon              | Optional, Hash           | Notification icon for web and android                       |

Click action hash keys

| Parameter | Usage                | description                      |
| --------- | -------------------- | -------------------------------- |
| :web      | Optional, String     | URL to open in browser           |
| :ios      | Optional, String     | Category in the APNs payload     |
| :android  | Optional, String     | Intent filter to launch Activity |

Icon hash keys

| key      | value type           | description                      |
| -------- | -------------------- | -------------------------------- |
| :web     | Optional, String     | Public absolute URL of icon      |
| :android | Optional, String     | Drawable resource name           | 

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

Add JavaScript FCM Client App to your Rails App ([instructions](https://firebase.google.com/docs/cloud-messaging/js/client)) without permission request, token access and notification showing. You just need to create FCM project in FCM console, link FCM libraries and put manifest file to public directory.

Add this lines to your layout file:
```erb
<script src="https://www.gstatic.com/firebasejs/5.4.1/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/5.4.1/firebase-messaging.js"></script>
<link rel="manifest" href="/manifest.json">
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

Init notifications showing, access to token and permission request:
```javascript
PUSHKIN.initNotifications();
PUSHKIN.requestPermission();
```

**Attention!** If you want to show push notifications while browser is closed, you still needs to implement this logic in *firebase-messaging-sw.js* yourself.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
