# Токены для отправки пуш уведомлений в приложения
module Pushkin
  class Token < ApplicationRecord

    belongs_to :user, optional: true

    validates :token, presence: true, uniqueness: { scope: :platform }
    validates :platform, presence: true
    validates_inclusion_of :is_active, in: [true, false]

    enum platform: [:android, :ios, :web]

    scope :active, -> { self.where(is_active: true) }

    # По умолчанию нужно работать только с активными устройствами.
    default_scope { self.active }

  end
end
