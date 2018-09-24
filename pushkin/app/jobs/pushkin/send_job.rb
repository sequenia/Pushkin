module Pushkin
  class SendJob < ApplicationJob

    queue_as :pushkin

    def perform(notification_id)
      SendPushService.new(notification_id).call
    end

  end
end