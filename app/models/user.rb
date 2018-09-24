class User < ApplicationRecord

  include Pushkin::Concerns::PushkinUser

  before_save :generate_auth_token

  def generate_auth_token
    return if self.auth_token.present?
    self.auth_token = loop do
      new_auth_token = SecureRandom.urlsafe_base64(nil, false)
      break new_auth_token unless User.where(auth_token: new_auth_token).any?
    end
  end

end
