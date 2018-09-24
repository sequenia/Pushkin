module Pushkin
  module TokenFilters
    class AndroidTokenFilter < TokenFilter

      def necessary?(token)
        token.android?
      end

      def get_sending_service(tokens, payload)
        Fcm::SendAndroidPushService.new(tokens, payload)
      end

    end
  end
end