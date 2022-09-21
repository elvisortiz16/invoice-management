# frozen_string_literal: true

RSpec.describe InvoiceService do
  subject { described_class }

  let(:receiver) { create(:user) }
  let(:emitter) { create(:user) }
  let(:invoice) { create(:invoice) }

  describe 'generate_filters' do
    it 'only add sent filters' do
      method = subject.generate_filters(Invoice.all, { status: :active })
      expect(method.where_values_hash.keys.count).to eq(1)
    end

    it 'allow only knowns filters' do
      method = subject.generate_filters(Invoice.all, { status: '', statuss: '' })
      expect(method.where_values_hash.keys.count).to eq(1)
    end

    context 'with each filter' do
      it 'type filter emitter' do
        method = subject.generate_filters(Invoice.all, { type: :emitter })
        expect(method.where_values_hash.keys).to include('emitter_id')
      end

      it 'amount filter' do
        method = subject.generate_filters(Invoice.all, { amount_range: '[0,1]' })
        expect(method.to_sql).to include('BETWEEN')
      end

      it 'misc filters' do
        filters = { status: '', emitter: '', receiver: '', emitted_at: '' }
        method = subject.generate_filters(Invoice.all, filters)
        expect(method.where_values_hash.keys.count).to eq(4)
      end
    end
  end

  describe 'get_all' do
    before do
      Current.user = emitter
      create_list(:invoice, 10, emitter:, receiver:)
      create_list(:invoice, 5, emitter: receiver, receiver: emitter)
    end

    it 'return all invoices' do
      expect(subject.get_all({}).count).to eq(15)
    end

    it 'return only emitted' do
      expect(subject.get_all({ type: 'emitter' }).count).to eq(10)
    end

    it 'return only received' do
      expect(subject.get_all({ type: 'receiver' }).count).to eq(5)
    end
  end

  describe 'get_total' do
    before do
      create(:invoice, currency: 'MXN')
      create(:invoice, currency: 'USD')
    end

    it 'return all totals' do
      expect(subject.get_total({}).keys).to include('MXN', 'USD')
    end
  end

  describe 'create, update and delete' do
    it 'create invoice' do
      subject.create({})
      expect(Invoice.count).to eq(1)
    end

    it 'update invoice' do
      method = subject.update(id: invoice.id)
      expect(method).to be(true)
    end

    it 'destroy invoice' do
      method = subject.destroy(id: invoice.id)
      expect(method).to eq(invoice)
    end
  end

  describe 'generate_qr' do
    before do
      qr_code_instance = instance_double(RQRCode::QRCode)
      allow(RQRCode::QRCode).to receive(:new).and_return(qr_code_instance)
      allow(qr_code_instance).to receive(:as_png).and_return(true)
    end

    it do
      subject.generate_qr(id: invoice.id)
      expect(RQRCode::QRCode).to have_received(:new).with(invoice.cfdi_digital_stamp)
    end
  end

  describe 'massive_upload' do
    before do
      allow(MassiveInvoicesJob).to receive(:perform_later).and_return(true)
    end

    let(:file) { fixture_file_upload( Rails.root.join('spec/fixtures/upload_example.zip')) }

    it 'start' do
      expect(subject.massive_upload_start({ file: })).to be_truthy
    end

    it 'finish' do
      expect(subject.massive_upload(file.tempfile.path)).to be_truthy
      expect(Invoice.count).to eq(10)
    end
  end
end
