# frozen_string_literal: true

class InvoiceService
  def self.get_all(params)
    query = Invoice.all
    generate_filters(query, params)
  end

  def self.get_total(params)
    query = Invoice.group(:currency)
    generate_filters(query, params)
    query.sum(:amount)
  end

  def self.generate_filters(query, params)
    type = ActiveRecord::Base.sanitize_sql(params[:type])
    query = query.where(type => Current.user) if type
    %i[status emitter receiver emitted_at].each do |key|
      query = query.where(key => params[key]) if params[key]
    end

    amount_range = JSON params[:amount_range]
    query = query.where(amount: amount_range[0]..amount_range[1]) if amount_range.size == 2
    query
  end

  def self.create(params)
    Invoice.create(build_params(params))
  end

  def self.update(params)
    Invoice.find(params[:id]).update(build_params(params))
  end

  def self.destroy(params)
    Invoice.destroy(params[:id])
  end

  def self.generate_qr(params)
    RQRCode::QRCode.new(Invoice.find(params[:id]).cfdi_digital_stamp).as_png(size: 500)
  end

  def self.build_params(params) # rubocop:disable Metrics/MethodLength
    emitter_rfc = params.dig(:emitter, :rfc)
    receiver_rfc = params.dig(:receiver, :rfc)
    invoice = {
      invoice_uuid: params[:invoice_uuid],
      status: params[:status],
      emitter_name: params.dig(:emitter, :name),
      emitter_rfc:,
      receiver_name: params.dig(:receiver, :name),
      receiver_rfc:,
      amount: params.dig(:amount, :cents),
      currency: params.dig(:amount, :currency),
      emitted_at: params[:emitted_at],
      expires_at: params[:expires_at],
      signed_at: params[:signed_at],
      cfdi_digital_stamp: params[:cfdi_digital_stamp]
    }
    invoice[:emitter] = User.find_by(tax_id: emitter_rfc)
    invoice[:receiver] = User.find_by(tax_id: receiver_rfc)
    invoice
  end
end
