# Базовый контроллер для всех остальных контроллеров Пушкина
module Pushkin::Api::V1::Concerns::ApiHelper

  extend ActiveSupport::Concern

  included do
    WRONG_API_KEY = "Wrong API key"

    # Проверяет переданный ключ API и возвращает ошибку в случае несовпадения.
    # Для минимальной защиты от несанкционированного доступа.
    def check_api_key!
      api_key = ENV["PUSHKIN_API_KEY"]
      raise Exception.new("No PUSHKIN_API_KEY in ENV") if api_key.blank?

      if api_key != params[:push_api_key]
        render :status => 403, :json => { :success => false, :info => WRONG_API_KEY }
      end
    end

    def render_bad_request(info, errors = nil)
      render_error(400, info, errors)
      return nil
    end

    def render_unprocessable_entity(info, errors = nil)
      render_error(422, info, errors)
      return nil
    end

    def render_error(status, info, errors)
      render :status => status, :json => { :success => false, :info => info, errors: errors }
      return nil
    end

    def render_success(info = nil, data = nil)
      response = { :success => true, info: info }
      response[:data] = data unless data.nil?
      render :json => response
      return nil
    end
  end

end