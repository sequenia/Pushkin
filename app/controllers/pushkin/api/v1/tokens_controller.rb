class Pushkin::Api::V1::TokensController < ApplicationController

  skip_before_action :verify_authenticity_token

  # Добавить здесь свою логику авторизации пользователя
  include AuthenticationHelper
  before_action :authenticate_user

  include Pushkin::Api::V1::Concerns::TokensHelper

  def current_pushkin_user
    # Возвратить ссылку на авторизованного пользователя
    current_user
  end

end