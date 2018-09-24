Pushkin.prototype.initNotifications = function() {
  this.trackTokenRefreshing();
  this.initNotificationsShow();
}

Pushkin.prototype.trackTokenRefreshing = function() {
  var _this = this;

  _this.messaging.onTokenRefresh(function() {
    _this.messaging.getToken().then(function(refreshedToken) {
      console.log('Token refreshed.');
      _this.setTokenSentToServer(false);
      _this.sendTokenToServerIfNeeds(refreshedToken);
    }).catch(function(err) {
      console.log('Unable to retrieve refreshed token ', err);
      _this.showToken('Unable to retrieve refreshed token ', err);
    });
  });
}

Pushkin.prototype.requestPermission = function() {
  var _this = this;
  console.log('Requesting permission...');
  _this.messaging.requestPermission().then(function() {
    console.log('Notification permission granted.');
    _this.getToken();
  }).catch(function(err) {
    console.log('Unable to get permission to notify.', err);
  });
}

Pushkin.prototype.getToken = function() {
  var _this = this;
  _this.messaging.getToken().then(function(currentToken) {
    if (currentToken) {
      _this.sendTokenToServerIfNeeds(currentToken);
    } else {
      console.log('No Instance ID token available. Request permission to generate one.');
      _this.setTokenSentToServer(false);
    }
  }).catch(function(err) {
    console.log('An error occurred while retrieving token. ', err);
    _this.setTokenSentToServer(false);
  });
}

Pushkin.prototype.sendTokenToServerIfNeeds = function(currentToken) {
  var _this = this;
  if (!_this.isTokenSentToServer()) {
    console.log('Sending token to server...');
    _this.sendFirebaseTokenToServer(currentToken);
  } else {
    console.log('Token already sent to server so won\'t send it again unless it changes');
  }
}

Pushkin.prototype.isTokenSentToServer = function() {
  return window.localStorage.getItem('sentToServer') === '1';
}

Pushkin.prototype.setTokenSentToServer = function(sent) {
  window.localStorage.setItem('sentToServer', sent ? '1' : '0');
}

Pushkin.prototype.initNotificationsShow = function() {
  var _this = this;
  _this.messaging.onMessage(function(payload) {
    console.log('Message received. ', payload);
    _this.showFirebaseMessage(payload);
  });
}

Pushkin.prototype.showFirebaseMessage = function(payload) {
  var _this = this;
  var notificationInfo = payload.notification;

  if(notificationInfo === undefined) {
    return undefined;
  }

  var notificationTitle = notificationInfo.title;
  var notificationOptions = {
    body: notificationInfo.body,
    icon: notificationInfo.icon,
    tag: notificationInfo.tag
  };

  var notification = new Notification(notificationTitle, notificationOptions);
  notification.onclick = function(event) {
    event.preventDefault();

    var clickAction = notificationInfo.click_action;
    if(clickAction !== undefined && window.location.pathname !== clickAction) {
      window.location = clickAction;
    }

    window.focus();
    notification.close();
  }
}