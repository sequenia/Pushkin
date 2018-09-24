module Pushkin
  module TokenFilters
    class WebTokenFilter < TokenFilter

      def necessary?(token)
        token.web?
      end

      def get_sending_service(tokens, payload)
        Fcm::SendWebPushService.new(tokens, payload)
      end

    end
  end
end