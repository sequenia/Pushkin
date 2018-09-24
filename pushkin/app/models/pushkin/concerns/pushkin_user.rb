# Базовый контроллер для всех остальных контроллеров Пушкина
module Pushkin::Concerns::PushkinUser

  extend ActiveSupport::Concern

  included do
    has_many :pushkin_tokens, class_name: "Pushkin::Token"
  end

end