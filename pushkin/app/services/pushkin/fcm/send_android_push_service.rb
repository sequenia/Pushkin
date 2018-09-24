module Pushkin
  module Fcm
    class SendAndroidPushService < SendFcmPushService

      def get_notification_hash
        notification_hash = super
        notification_hash[:icon] = self.payload.android_icon if self.payload.android_icon.present?
        notification_hash[:click_action] = self.payload.android_click_action if self.payload.android_click_action.present?
        notification_hash
      end

      def get_platform
        :android
      end

      def is_data_message
        self.payload.is_android_data_message
      end

    end
  end
end