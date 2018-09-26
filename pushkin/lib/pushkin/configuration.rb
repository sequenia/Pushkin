module Pushkin
  class Configuration

    include Singleton

    attr_accessor :fcm_server_key

    def fcm_server_key
      @fcm_server_key ||= ENV["FCM_SERVER_KEY"]
    end

  end
end