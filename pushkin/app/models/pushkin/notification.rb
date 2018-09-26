# Уведомление для отправки
module Pushkin
  class Notification < ApplicationRecord

    # Предоставляет токены устройств, на которые нужно отправить уведомление.
    # polymorphic сделан для того, чтобы можно было реализовывать различные логики
    # получения токенов для конкретного уведомления, например:
    # - В момент планирования уведомления сохранить в базу пользователей, которым нужно отправить уведомления.
    #   В момент отправки для этих пользователей будут получены актуальные устройства.
    #   Данная реализация находится в Pushkin::TokensProvider
    # - В момент планирования уведомления сохранить в базу токены, на которые будет отправлено уведомление.
    # - В момент планирования сохранить ссылку на какую-нибо сущность, из которой в момент отправки
    #   будет получен актуальный список токенов пользователей.
    belongs_to :tokens_provider, polymorphic: true, dependent: :destroy

    # Предоставляет данные, которые будут отправлены в пуш уведомлении.
    # polymorphic нужен для того, чтобы реализовывать различные способы получения данных
    # для различных уведомлений, например:
    # - В момент планирования уведомления сохранить всю информацию в базу в статическом виде.
    #   Такая релизация находится в Pushkin::Payload
    # - В момент планированя уведомления сохранить какую-либо сущность, которая в момент отправки
    #   уведомления предоставит нужную актуальную информацию на лету.
    belongs_to :payload, polymorphic: true, dependent: :destroy, inverse_of: :notification

    # Статистика по отправленным сообщениям. Один объект - одна групповая отправка.
    has_many :push_sending_results, dependent: :destroy
    has_many :token_results, through: :push_sending_results

    # Тип уведомления для разделения уведомлений по назначениям.
    # Обязательный, чтобы потом не запутаться и легко фильтроваться.
    validates :notification_type, presence: true

    # Отправляет уведомление прямо сейчас
    def send_now(async: true)
      # Заполняем как дату, в которую нужно отправить, так и дату, в которую началась отправка.
      # Это позволит периодической операции по отправке уведомлений не отвлекаться на такое уведомление.
      now = DateTime.now
      self.update_attributes(start_at: now, started_at: now)
      async ? SendJob.perform_later(self.id) : SendPushService.new(self.id).call
    end
  end
end