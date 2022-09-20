# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from CustomException, with: :render_custom_exception
  before_action :set_locale, :set_current_user

  def set_locale
    I18n.locale = request.headers[:locale] || I18n.default_locale
  end

  def set_current_user
    return if request.headers[:token].blank?

    decoded_token = JSON JWT.decode(request.headers[:token], 'secret', true, { algorithm: 'HS256' })[0]
    Current.user ||= User.find_by(id: decoded_token['id'])
  end

  def logged_in?
    render json: { error: I18n.t('user.loggin_error') }, status: :unauthorized if Current.user.nil?
  end

  def render_custom_exception(error)
    render json: { error: }, status: :unauthorized if Current.user.nil?
  end
end
