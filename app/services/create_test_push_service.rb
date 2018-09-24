class CreateTestPushService

  def initialize
  end

  def call
    Pushkin::NotificationFabric.new.simple_notification_to_users({
      notification_type: "notification_test",
      users: User.all,
      title: "Test",
      body: "Push-Notification Test",
      click_action: {
        web: "http://localhost:3000"
      },
      icon: nil,
      is_data_message: {
        ios: false,
        android: true,
        web: false
      },
      data: {
        key1: "aaaa",
        key2: "bbbb"
      }
    })
  end

end