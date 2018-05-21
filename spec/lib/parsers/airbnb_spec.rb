require 'rails_helper'

RSpec.describe Parsers::Airbnb do
  let!(:account) { create(:account) }

  describe '#billing_emails' do
    let(:marketing_msg) { double(raw_message: { 'X-Template' => double(value: 'some') }) }
    let(:billing_msg) { double(raw_message: { 'X-Template' => double(value: 'billing_receipt') }) }
    let(:gmail) { double }

    before do
      allow(gmail).to receive_message_chain('inbox.emails').and_return([marketing_msg, billing_msg])
    end

    subject { described_class.new(gmail, account).billing_emails }

    it { is_expected.to eq([billing_msg]) }
  end

  describe '#populate_transactions' do
    let(:raw_msg) { YAML.load(File.read(Rails.root.to_s+'/spec/assets/billing_msg.dump')) }
    let(:message_id) { '123456' }
    let(:message_obj) { double(message_id: message_id) }
    let(:gmail) { double }

    before do
      allow(message_obj).to receive_message_chain("html_part.body.decoded").and_return(raw_msg)
      allow_any_instance_of(described_class).to receive(:billing_emails).and_return([message_obj])
      described_class.new(gmail, account).populate_transactions
    end

    subject { Transaction.first }

    it { expect(Transaction.count).to eq(1) }
    its(:service) { is_expected.to eq('airbnb') }
    its(:account) { is_expected.to eq(account) }
    its(:message_uid) { is_expected.to eq(message_id) }
    its(:purchased_at) { is_expected.to eq("2016-12-10 20:23:37") }
    its(:value_cents) { is_expected.to eq(15900) }
    its(:details) do
      is_expected.to eq({:location=>"Rosengården 14A, Копенгаген, 1174, Дания",
                         :appartments=>"Unique apartment in the centre of Copenhagen",
                         :nights=>"2"})
    end
  end
end
