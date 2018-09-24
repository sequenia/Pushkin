# Контроллер по управлению PUSH токенами
module Pushkin::Api::V1::Concerns::TokensHelper

  extend ActiveSupport::Concern

  included do

    include Pushkin::Api::V1::Concerns::ApiHelper

    before_action :check_api_key!
    before_action :init_creation_params!, only: [:create]

    EMPTY_TOKEN_ERROR = "param 'token' is empty"
    EMPTY_PLATFORM_ERROR = "params 'platform' is empty"
    TOKEN_NOT_CREATED_ERROR = "token not created"
    USER_NOT_SAVED_ERROR = "user not saved"
    OLD_TOKEN_ERROR = "old token not disactivated"
    TOKEN_NOT_ACTIVATED = "token not activated"

    # Создает токен, если он не существует.
    # Прикрепляет токен к пользователю, если пользователь авторизован.
    # Помечает старый токен неактивным, если передана соответствующая информация.
    def create
      @token = Pushkin::Token.unscoped.where(token_attributes).first

      # Сохранение токена в БД, если его еще не существует
      if @token.nil?
        @token = Pushkin::Token.create(token_attributes)
        return render_token_not_created if @token.errors.present?
      end

      # Привязка/Отвязка пользователя с токеном.
      if @token.user_id != @user_id
        @token.update_attributes(user_id: @user_id)
        return render_user_not_saved if @token.errors.present?
      end

      # Если вдруг каким-то обрабом токен помечен как неактивный, это нужно исправить
      unless @token.is_active
        @token.update_attributes(is_active: true)
        return render_token_not_activated if @token.errors.present?
      end

      # Если передана информация о старом токене, его нужно деактивировать.
      if @old_token_string.present?
        if @old_token = Pushkin::Token.unscoped.where(token_attributes(@old_token_string)).first
          @old_token.update_attributes(is_active: false)
          return render_old_token_error if @old_token.errors.present?
        end
      end

      render_success("Done")
    end

    def init_creation_params!
      @token_string = token_params[:token]
      @platform = token_params[:platform]
      @old_token_string = token_params[:old_token]
      @user_id = current_pushkin_user ? current_pushkin_user.id : nil

      return render_bad_request(EMPTY_TOKEN_ERROR) if @token_string.blank?
      return render_bad_request(EMPTY_PLATFORM_ERROR) if @platform.blank?
    end

    def token_params
      @token_params ||= params.require(:push_token_info).permit(:token, :platform, :old_token)
    end

    def token_attributes(token_string = @token_string)
      { token: token_string, platform: @platform }
    end

    def render_token_not_created
      render_unprocessable_entity(TOKEN_NOT_CREATED_ERROR, @token.errors.messages)
    end

    def render_user_not_saved
      render_unprocessable_entity(USER_NOT_SAVED_ERROR, @token.errors.messages)
    end

    def render_token_not_activated
      render_unprocessable_entity(TOKEN_NOT_ACTIVATED, @token.errors.messages)
    end

    def render_old_token_error
      render_unprocessable_entity(OLD_TOKEN_ERROR, @old_token.errors.messages)
    end

    def current_pushkin_user
      nil
    end
  end

end