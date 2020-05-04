require 'rails_helper'

RSpec.describe MembershipApplication::Steps do
  subject(:steps) { MembershipApplication::Steps.instance }

  describe '#step_names' do
    subject { steps.step_names }

    it { is_expected.to include('about-you') }
  end

  describe '#index_of' do
    it 'gets the index of a given step' do
      aggregate_failures do
        expect(steps.index_of('about-you')).to eql(0)
        expect(steps.index_of('contact-details')).to eql(1)
        expect { steps.index_of('non-existent') }.to raise_error(KeyError)
      end
    end
  end

  describe '#reached_step?' do
    subject { steps.reached_step?(step, 'about-you') }

    context 'the application is new' do
      let(:step) { nil }

      it { is_expected.to be false }
    end

    context 'the application is at the current step' do
      let(:step) { 'about-you' }

      it { is_expected.to be true }
    end

    context 'the application is beyond the current step' do
      let(:step) { 'contact-details' }

      it { is_expected.to be true }
    end
  end
end
