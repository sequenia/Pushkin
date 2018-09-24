# Отправляет пуш уведомления через firebase.
# Это базовый класс для наследников, специфических для платформ
module Pushkin
  module Fcm
    class SendFcmPushService

      FCM_API_DOMAIN = "https://fcm.googleapis.com"
      FCM_API_URL = "/fcm/send"

      attr_accessor :tokens, :payload
      attr_accessor :server_key

      def initialize(tokens, payload)
        @tokens = tokens
        @payload = payload
        @server_key = ENV["FCM_SERVER_KEY"]
        raise Exception.new("No FCM_SERVER_KEY in ENV") if @server_key.blank?
      end

      def call
        # Сохранение в БД информации по отправке
        @push_sending_result = PushSendingResult.create(started_at: DateTime.now, platform: self.get_platform)

        # Выполнение HTTP запроса по отправке уведомлений
        conn = Faraday.new(:url => FCM_API_DOMAIN)
        response = conn.post do |req|
          req.url FCM_API_URL
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "key=#{self.server_key}"
          req.body = self.get_request_body.to_json
        end

        # Сохранение результатов отправки в БД
        self.process_response(response)
        @push_sending_result
      end

      def process_response(response)
        @push_sending_result.finished_at = DateTime.now

        if response.status == 200
          @push_sending_result.success = true

          # Обработка ответа с сохранением в БД
          response_body = JSON.parse(response.body, symbolize_names: true)
          response_body[:results].each_with_index.map do |result, index|
            token_result = self.parse_token_result(result, self.tokens[index])
            token_result.push_sending_result_id = @push_sending_result.id
            token_result.save
          end
        else
          @push_sending_result.success = false
          @push_sending_result.error = response.body
        end

        @push_sending_result.save
      end

      def parse_token_result(result, token)
        error = result[:error]
        token_result = TokenResult.new(token_id: token.id)

        if error.blank?
          token_result.set_success
        elsif error == "NotRegistered" || error == "InvalidRegistration"
          token_result.set_invalid
        else
          token_result.set_error(error)
        end

        token_result.save
        token_result
      end

      def get_request_body
        body = {
          registration_ids: self.tokens.map { |token_object| token_object.token },
          content_available: self.is_data_message
        }

        notification_hash = self.get_notification_hash
        data_hash = self.get_data_hash

        if self.is_data_message
          data_hash = data_hash.merge(notification_hash)
          notification_hash = nil
        end

        body[:notification] = notification_hash if notification_hash.present?
        body[:data] = data_hash if data_hash.present?

        body
      end

      def get_notification_hash
        return {
          title: self.payload.title,
          body: self.payload.body,
          tag: self.payload.notification.id.to_s
        }
      end

      def get_data_hash
        (self.payload.data || {}).merge({
          notification_type: self.payload.notification.notification_type,
          notification_id: self.payload.notification.id
        })
      end

      def get_platform
        raise Exception.new("You must implement 'get_platform' method in child class")
      end

      def is_data_message
        raise Exception.new("You must implement 'is_data_message' method in child class")
      end

    end
  end
end