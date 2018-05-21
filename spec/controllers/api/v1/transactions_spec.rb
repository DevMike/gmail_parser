require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let(:params) { {} }

  def make_request
    public_send http_method, action_name, params: params
  end

  describe 'GET /api/v1/transactions/populate' do
    let(:http_method) { :get }
    let(:action_name) { 'populate' }
    let(:stubbed_omniauth) { double }

    before do
      allow(stubbed_omniauth).to receive_message_chain('info.email')
      allow(stubbed_omniauth).to receive_message_chain('credentials.token')
      request.env["omniauth.auth"] = stubbed_omniauth
    end

    context 'authorized' do
      before { allow(Gmail).to receive(:connect!) }

      it { expect{ make_request }.to change(Account, :count).by(1) }

      it 'response status' do
        make_request
        expect(response).to be_success
      end

      it 'response status to be ok' do
        expect(ParseEmailsJob).to receive(:perform_later)
        make_request
      end
    end

    context 'not authorized' do
      it { expect{ make_request }.not_to change(Account, :count) }

      it 'response status' do
        make_request
        expect(response).to_not be_success
      end

      it 'response status to be ok' do
        expect(ParseEmailsJob).not_to receive(:perform_later)
        make_request
      end
    end
  end

  describe 'GET /api/v1/transactions/' do
    let!(:transactions) { create_list(:transaction, 1) }

    let(:http_method) { :get }
    let(:action_name) { 'index' }

    before { make_request }

    it { expect(response.body).to eq(transactions.map(&:as_json).to_json) }
  end
end
