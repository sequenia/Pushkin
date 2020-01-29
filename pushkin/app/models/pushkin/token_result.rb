module Pushkin
  class TokenResult < ApplicationRecord

    STATUS_SUCCESS = "success"
    STATUS_INVALID = "invalid"
    STATUS_ERROR = "error"

    belongs_to :push_sending_result, optional: true
    belongs_to :token, -> { with_not_active }

    scope :invalid, -> { self.where(status: STATUS_INVALID) }

    def set_success
      self.status = STATUS_SUCCESS
    end

    def set_invalid
      self.status = STATUS_INVALID
    end

    def set_error(error)
      self.status = STATUS_ERROR
      self.error = error
    end

    def success?
      self.status == STATUS_SUCCESS
    end

    def invalid?
      self.status == STATUS_INVALID
    end

    def error?
      self.status == STATUS_ERROR
    end

  end
end