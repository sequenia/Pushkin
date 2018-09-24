require "pushkin/engine"

module Pushkin

  def self.android_provider
    @@android_provider ||= :fcm
  end

  def self.ios_provider
    @@ios_provider ||= :fcm
  end

  def self.web_provider
    @@web_provider ||= :fcm
  end

  def self.android_provider=(value)
    @@android_provider = value
  end

  def self.ios_provider=(value)
    @@ios_provider = value
  end

  def self.web_provider=(value)
    @@web_provider = value
  end

end
