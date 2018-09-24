# Статическая информация, отправляемая в пуш уведомлении
module Pushkin
  class Payload < ApplicationRecord

    # Связь с уведомлением, к которому относится данная информация
    has_one :notification, as: :payload, inverse_of: :payload

    validates :title, presence: true

    def data
      value = read_attribute(:data)
      value = value.present? ? JSON.parse(value, symbolize_names: true) : {}
      value
    end

    def data=(value)
      write_attribute(:data, value.present? ? value.to_json : value)
    end

  end
end
