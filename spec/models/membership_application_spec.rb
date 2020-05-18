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

    it 'still has an empty resumption token' do
      expect(application.dropped_cart_resumption_token).to be_nil
    end

    context 'it is saved' do
      before { application.save! }

      it 'creates a 24-character base58 resumption token' do
        expect(application.dropped_cart_resumption_token).to match(/[0-9a-zA-Z]{24}/)
      end
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

  context 'the your-work step' do
    subject(:application) do
      build :membership_application, :step_your_work, school_roll_number: school_roll_number
    end

    context 'a bad school_roll_number is given' do
      let(:school_roll_number) { '123' }

      it 'tells us how to fix it' do
        expect(application).not_to be_valid
        expect(application.errors[:school_roll_number]).to eql(
          ['should be five digits followed by a letter']
        )
      end
    end

    context 'a good school_roll_number is given' do
      let(:school_roll_number) { '20771J' }
      it { is_expected.to be_valid }
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

    context 'the declaration is provided but not case-sensitive' do
      before { application.declaration = 'natalie Zurbman' }

      it { is_expected.to be_valid }
    end

    context 'the declaration is provided but with trailing spaces' do
      before { application.declaration = 'Natalie Zurbman ' }

      it { is_expected.to be_valid }
    end

    context 'the declaration is provided but not case-sensitive and with spaces' do
      before { application.declaration = 'Natalie zurbman ' }

      it { is_expected.to be_valid }
    end

    context 'the declaration is provided but not case-sensitive and with spaces all over' do
      before { application.declaration = ' Natalie   zurbman ' }

      it { is_expected.to be_valid }
    end

    describe 'the token before and after signature' do
      let(:application) { create :membership_application, :step_your_subscription_rate }

      before do
        expect(application.dropped_cart_resumption_token).to be_present
        application.current_step = 'declaration'
        application.declaration = "#{application.first_name} #{application.last_name}"
        application.save!
      end

      it 'nils itself' do
        expect(application.dropped_cart_resumption_token).to be_nil
      end
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
