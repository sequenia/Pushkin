# Создает уведомления в БД по переданным данным
module Pushkin
  class NotificationFabric

    # Создает уведомление со статическими данными.
    # Актуальный список устройств, на которые нужно отправить уведомления,
    # будут получены из пользователей в момент отправки.
    def simple_notification_to_users(users: [], title: [], body: [],
                                     is_data_message: false, click_action: nil, icon: nil,
                                     data: {}, notification_type: nil)
      return nil if users.blank?

      payload_attrs = { title: title, body: body, data: data }
      payload_attrs = payload_attrs.merge(self.is_data_message_attrs(is_data_message))
      payload_attrs = payload_attrs.merge(self.click_action_attrs(click_action))
      payload_attrs = payload_attrs.merge(self.icon_attrs(icon))
      payload = Payload.create(payload_attrs)

      tokens_provider = TokensProvider.create(users: users)

      Notification.create(notification_type: notification_type,
                          payload: payload,
                          tokens_provider: tokens_provider)
    end

    def is_data_message_attrs(is_data_message = false)
      if is_data_message.is_a? Hash
        is_android_data_message = is_data_message[:android]
        is_ios_data_message = is_data_message[:ios]
        is_web_data_message = is_data_message[:web]

        is_android_data_message = false if is_android_data_message.nil?
        is_ios_data_message = false if is_ios_data_message.nil?
        is_web_data_message = false if is_web_data_message.nil?

        return {
          is_android_data_message: is_android_data_message,
          is_ios_data_message: is_ios_data_message,
          is_web_data_message: is_web_data_message
        }
      else
        return {
          is_android_data_message: is_data_message,
          is_ios_data_message: is_data_message,
          is_web_data_message: is_data_message
        }
      end
    end

    def click_action_attrs(click_action = nil)
      if click_action.is_a? Hash
        return {
          android_click_action: click_action[:android],
          ios_click_action: click_action[:ios],
          web_click_action: click_action[:web]
        }
      else
        return {
          android_click_action: click_action,
          ios_click_action: click_action,
          web_click_action: click_action
        }
      end
    end

    def icon_attrs(icon = nil)
      if icon.is_a? Hash
        return {
          android_icon: icon[:android],
          ios_icon: icon[:ios],
          web_icon: icon[:web]
        }
      else
        return {
          android_icon: icon,
          ios_icon: icon,
          web_icon: icon
        }
      end
    end

  end
end