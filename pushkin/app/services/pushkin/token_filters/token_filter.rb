# Фильтрует токены по принадлежности к платформе
# и предоставляет сервис по отправке уведомлений на эту конкретную платформу
module Pushkin
  module TokenFilters
    class TokenFilter

      # Фильтрует токены по принадлежности к платформе и возвращает новый список
      def filter_tokens(tokens)
        (tokens.to_a || []).select { |token| self.necessary?(token) }
      end

      # Возвращает true, если переданный token принадлежит нужной платформе
      def necessary?(token)
        raise Exception.new("You must implement 'necessary?' method")
      end

      # Возвращает экземпляр сервиса по отправке уведомлений на конкретную платформу
      def get_sending_service(tokens, payload)
        raise Exception.new("You must implement 'get_sending_service' method")
      end

    end
  end
end