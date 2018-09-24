# Связка Провайдер-Пользователь для отправки пуш уведомлений
module Pushkin
  class TokensProviderUser < ApplicationRecord

    # Ссылка на пользователя
    belongs_to :user

    # Ссылка на провайдер (Связывает уведомление и пользователей, которым нужно отправить уведомление)
    belongs_to :tokens_provider, optional: true

  end
end
