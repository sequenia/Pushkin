# Результат отправки на платформу
module Pushkin
  class PushSendingResult < ApplicationRecord

    belongs_to :notification, optional: true

    has_many :token_results, dependent: :destroy

    # Соответствует платформам в токенах
    enum platform: [:android, :ios, :web]

  end
end
