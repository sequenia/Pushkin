# Отправляет уведомление на все платформы,
# сохраняет статистику по отправке в БД,
# и обновляет инорфмацию об активности токенов
module Pushkin
  class SendPushService

    def initialize(notification_id)
      @notification = Notification.find(notification_id)
    end

    def call
      # Получим все токены, на которые нужно отправлять уведомления.
      all_tokens = @notification.tokens_provider.get_tokens.to_a

      # Создаем список помощников, которые отфильтруют уведомления по платформам.
      # Они так же предоставляют соответствующие сервисы для отправки уведомлений.
      token_filters = [Pushkin::TokenFilters::IosTokenFilter.new,
                       Pushkin::TokenFilters::AndroidTokenFilter.new,
                       Pushkin::TokenFilters::WebTokenFilter.new]

      # Отправка на конкретные платформы
      push_sending_results = token_filters.map do |token_filter|
        tokens = token_filter.filter_tokens(all_tokens)
        token_filter.get_sending_service(tokens, @notification.payload).call if tokens.present?
      end

       # Актуализация информации об активности токенов
      push_sending_results.compact.each do |push_sending_result|
        push_sending_result.update_attributes(notification_id: @notification.id)
        push_sending_result.token_results.joins(:token).invalid.each do |token_result|
          token_result.token.update_attributes(is_active: false)
        end
      end

      @notification.update_attributes(finished_at: DateTime.now)
    end

  end
end