require 'rails_helper'

RSpec.describe View::DateRangeQuery do
  subject(:query) { View::DateRangeQuery.new(params) }

  context 'there are no params' do
    let(:params) { {} }

    it { is_expected.to be_valid }
    it { is_expected.to be_empty }
  end

  context 'one of the params is bad' do
    let(:params) { { from_date: 'not_a_date', to_date: '2020-04-21' } }

    it { is_expected.not_to be_valid }
  end

  context 'both the dates are fine' do
    let(:params) { { from_date: '2020-04-20', to_date: '2020-04-21' } }

    it { is_expected.to be_valid }

    it do
      expect(query.range).to eql(Time.zone.parse('2020-04-20')..Time.zone.parse('2020-04-21'))
    end
  end

  context 'the to date is before the from date' do
    let(:params) { { from_date: '2020-04-22', to_date: '2020-04-21' } }

    it 'has the error' do
      aggregate_failures do
        expect(query).not_to be_valid
        expect(query.errors[:from_date]).to eql(['from date is after to date'])
      end
    end
  end
end
