module Pushkin
  class Configuration

    include Singleton

    attr_accessor :fcm_server_key, :user_class_name

    def fcm_server_key
      @fcm_server_key ||= ENV["FCM_SERVER_KEY"]
    end

    def user_class_name
      @user_class_name ||= "User"
    end

  end
end