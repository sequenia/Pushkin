# Возвращает токены устройств для пользователей, которые к нему прикреплены
module Pushkin
  class TokensProvider < ApplicationRecord

    # Ссылка на уведомление
    has_one :notification, as: :tokens_provider

    # Ссылки на пользователей
    has_many :tokens_provider_users, foreign_key: :tokens_provider_id,
                                     dependent: :destroy

    # Пользователи, которым нужно отправить пуш-уведомление
    has_many :users, through: :tokens_provider_users

    # Возвращает список токенов для отправки пуш уведомления.
    # Токен - объект PushToken.
    def get_tokens
      self.users.includes(:pushkin_tokens).map { |user| user.pushkin_tokens }.flatten
    end

  end
end
