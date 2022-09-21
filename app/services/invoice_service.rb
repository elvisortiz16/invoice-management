# frozen_string_literal: true

require 'zip'

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

  def self.massive_upload_start(params)
    # asumming the file is at the same server, if we use blob storage we need to change this code
    MassiveInvoicesJob.perform_later(params[:file].tempfile.path)
    true
  end

  def self.massive_upload(path)
    invoices = []
    Zip::File.open(path) do |files|
      files.each do |file|
        xml = Hash.from_xml(file.get_input_stream.read)['hash'].deep_symbolize_keys
        invoices.push(build_params(xml).merge(created_at: Time.zone.now, updated_at: Time.zone.now))
      end
    end
    Invoice.insert_all!(invoices)
  end

  def self.build_params(params) # rubocop:disable Metrics/MethodLength
    emitter_rfc = params.dig(:emitter, :rfc)
    receiver_rfc = params.dig(:receiver, :rfc)
    {
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
      cfdi_digital_stamp: params[:cfdi_digital_stamp],
      emitter_id: User.find_by(tax_id: emitter_rfc)&.id,
      receiver_id: User.find_by(tax_id: receiver_rfc)&.id
    }
  end
end
