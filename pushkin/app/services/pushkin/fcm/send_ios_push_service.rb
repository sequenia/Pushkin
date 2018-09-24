module Pushkin
  module Fcm
    class SendIosPushService < SendFcmPushService

      def get_notification_hash
        notification_hash = super
        notification_hash[:icon] = self.payload.ios_icon if self.payload.ios_icon.present?
        notification_hash[:click_action] = self.payload.ios_click_action if self.payload.ios_click_action.present?
        notification_hash
      end

      def get_platform
        :ios
      end

      def is_data_message
        self.payload.is_ios_data_message
      end

    end
  end
end