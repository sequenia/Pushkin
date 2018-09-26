require "pushkin/engine"
require "pushkin/configuration"

module Pushkin

  def self.config
    Pushkin::Configuration.instance
  end

  def self.configure(&block)
    block.call(Pushkin.config)
  end

  def self.simple_notification_to_users(*args)
    Pushkin::NotificationFabric.new.simple_notification_to_users(*args)
  end

end
