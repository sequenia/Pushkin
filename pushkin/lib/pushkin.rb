require "pushkin/engine"

module Pushkin

  def self.simple_notification_to_users(*args)
    Pushkin::NotificationFabric.new.simple_notification_to_users(*args)
  end

end
