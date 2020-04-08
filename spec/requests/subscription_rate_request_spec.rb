require 'rails_helper'

RSpec.describe '/subscription-rate', type: :request do
  let(:path)   { '/subscription-rate' }
  let(:params) { {} }

  before { get path, params: params, headers: headers }

  context 'HTML get is attempted' do
    let(:headers) { { 'Accept' => 'text/html' } }

    it 'is unacceptable' do
      expect(response.status).to eql(406)
    end
  end

  context 'JSON get' do
    let(:headers) { { 'Accept' => 'application/json' } }

    subject(:json) { JSON.parse(response.body) }

    context 'parameters are missing' do
      it 'is a bad request' do
        expect(response.status).to eql(400)
      end

      it 'tells us why' do
        expect(json).to eql('error' => 'pay_rate is required')
      end
    end

    context 'parameters are all present' do
      context 'and do not have any special characters' do
        let(:params) { { 'pay_rate': '15.50', 'pay_unit': 'hour', hours_per_week: '25' } }

        it 'gets us some JSON with a monthly_estimate in it' do
          expect(json).to eql('monthly_estimate' => '13.43')
        end
      end

      context 'and have special characters' do
        let(:params) { { 'pay_rate': '£€15.50', 'pay_unit': 'hour', hours_per_week: '25' } }
        it 'strips them before processing' do
          expect(json).to eql('monthly_estimate' => '13.43')
        end
      end
    end
  end
end
