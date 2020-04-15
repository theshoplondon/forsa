require 'rails_helper'

RSpec.describe MembershipApplication, type: :model do
  subject(:application) do
    build :membership_application, "step_#{step.underscore}".to_sym
  end

  context 'the current_step is not set' do
    let(:step) { 'new' }

    it 'only validates first name and email' do
      expect(application).to be_valid
    end
  end

  context 'the current_step is the first one, about-you' do
    let(:step) { 'about-you' }

    before { application.last_name = nil }

    it 'now validates parameters from the second step' do
      aggregate_failures do
        expect(application).not_to be_valid

        expect(application.errors[:last_name]).to eql ["can't be blank"]
      end
    end
  end

  context 'the current_step is the second step, contact-details' do
    let(:step) { 'contact-details' }

    context 'and some of the details from the previous step are removed' do
      before do
        application.last_name = nil
        application.date_of_birth = nil
        application.phone_number = nil
        application.home_address = nil
      end

      it 'still validates the previous step along with the current step' do
        aggregate_failures do
          expect(application).not_to be_valid

          expect(application.errors[:last_name]).to eql ["can't be blank"]
          expect(application.errors[:date_of_birth]).to eql ["can't be blank"]
          expect(application.errors[:home_address]).to eql ["can't be blank"]
          expect(application.errors[:phone_number]).to eql ["can't be blank"]
        end
      end
    end

    context 'and some of the details from the current step are not filled in' do
      let(:step) { 'contact-details' }

      before { application.last_name = nil }

      it 'is not valid' do
        aggregate_failures do
          expect(application).not_to be_valid

          expect(application.errors[:last_name]).to eql ["can't be blank"]
        end
      end
    end
  end

  context 'the final step requires a signature' do
    let(:step) { 'declaration' }

    context 'which is not provided' do
      before { application.declaration = nil }

      it 'fails with a single message' do
        expect(application).not_to be_valid

        expect(application.errors.count).to eql 1
        expect(application.errors[:declaration]).to eql(['must be "Natalie Zurbman"'])
      end
    end

    context 'the declaration is provided' do
      before { application.declaration = 'Natalie Zurbman' }

      it { is_expected.to be_valid }
    end
  end

  describe '#completed?' do
    let(:application) { create :membership_application, "step_#{step.underscore}".to_sym }

    subject { application.completed? }

    context 'we are not yet at declaration' do
      let(:step) { 'contact-details' }
      it { is_expected.to be false }
    end

    context 'we are at the declaration step' do
      context 'but it is not saved' do
        let(:step) { 'your-subscription-rate' }
        before { application.current_step = 'declaration' }

        it { is_expected.to be false }
      end
      context 'and it is saved' do
        let(:step) { 'declaration' }

        it { is_expected.to be true }
      end
    end
  end
end
