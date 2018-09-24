module Pushkin
  module TokenFilters
    class IosTokenFilter < TokenFilter

      def necessary?(token)
        token.ios?
      end

      def get_sending_service(tokens, payload)
        Fcm::SendIosPushService.new(tokens, payload)
      end

    end
  end
end