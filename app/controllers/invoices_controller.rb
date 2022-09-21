# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :logged_in?
  def index
    render json: InvoiceService.get_all(allowed_filters_params)
  end

  def create
    render json: InvoiceService.create(create_update_params)
  end

  def update
    render json: InvoiceService.update(create_update_params)
  end

  def destroy
    render json: InvoiceService.destroy(params)
  end

  def total
    render json: InvoiceService.get_total(allowed_filters_params)
  end

  def generate_qr
    data = InvoiceService.generate_qr(params)
    send_data data, type: 'image/png'
  end

  def massive_upload
    render json: InvoiceService.massive_upload_start(params.permit(:file))
  end

  def allowed_filters_params
    params.permit(
      :type, :status, :emitter, :receiver, :amount_range, :emitted_at
    )
  end

  def create_update_params # rubocop:disable Metrics/MethodLength
    params.permit(
      :id,
      :invoice_uuid,
      :status,
      :emitted_at,
      :expires_at,
      :signed_at,
      :cfdi_digital_stamp,
      emitter: %i[name rfc],
      receiver: %i[name rfc],
      amount: %i[cents currency]
    )
  end
end
