# Базовый контроллер для всех остальных контроллеров Пушкина
module Pushkin::Api::V1::Concerns::ApiHelper

  extend ActiveSupport::Concern

  included do

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