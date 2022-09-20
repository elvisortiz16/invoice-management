# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    raise CustomException, I18n.t('user.not_found') unless user.present? && user.password == params[:password]

    token = JWT.encode(user.to_json, 'secret', 'HS256')
    render json: { token: }
  end
end
