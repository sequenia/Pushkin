module Pushkin
  module Fcm
    class SendWebPushService < SendFcmPushService

      def get_notification_hash
        notification_hash = super
        notification_hash[:icon] = self.payload.web_icon if self.payload.web_icon.present?
        notification_hash[:click_action] = self.payload.web_click_action if self.payload.web_click_action.present?
        notification_hash
      end

      def get_platform
        :web
      end

      def is_data_message
        self.payload.is_web_data_message
      end

    end
  end
end