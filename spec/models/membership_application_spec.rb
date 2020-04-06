require 'rails_helper'

RSpec.describe MembershipApplication do
  subject(:application) { MembershipApplication.new(params) }

  before { application.validate }

  context 'the current_step is not set' do
    let(:params) do
      { first_name: 'Natalie', email: 'n@example.com' }
    end

    it 'only validates first name and email' do
      expect(application).to be_valid
    end
  end

  context 'the current_step is the first one, about-you' do
    let(:params) do
      { current_step: 'about-you', first_name: 'Natalie', email: 'n.example.com' }
    end

    it 'now validates parameters from the second step' do
      aggregate_failures do
        expect(application).not_to be_valid

        expect(application.errors[:last_name]).to eql ["can't be blank"]
        expect(application.errors[:date_of_birth]).to eql ["can't be blank"]
      end
    end
  end

  context 'the current_step is the second step, contact-details' do
    context 'and some of the details from the previous step are removed' do
      let(:params) do
        { current_step: 'contact-details', first_name: 'Natalie', email: 'n.example.com' }
      end

      it 'still validates the previous step along with the current step' do
        aggregate_failures do
          expect(application).not_to be_valid

          expect(application.errors[:last_name]).to eql ["can't be blank"]
          expect(application.errors[:date_of_birth]).to eql ["can't be blank"]
          expect(application.errors[:phone_number]).to eql ["can't be blank"]
        end
      end
    end

    context 'and some of the details from the current step are not filled in' do
      let(:params) do
        {
          current_step: 'contact-details',
          first_name: 'Natalie',
          email: 'n.example.com',
          title: 'Ms'
        }
      end

      it 'is not valid' do
        aggregate_failures do
          expect(application).not_to be_valid

          expect(application.errors[:last_name]).to eql ["can't be blank"]
        end
      end
    end
  end

  context 'the final step requires a signature' do
    let(:params) do
      {
        current_step: 'declaration',
        first_name: 'Natalie',
        last_name: 'Zurbman',
        email: 'n@example.com',
        date_of_birth: '19/04/1973',
        phone_number: '02345678',
        job_title: 'Accountant',
        employer: 'Office of Public Works',
        work_address: 'Somewhere',
        payroll_number: '1234',
        pay_rate: '35000',
        pay_unit: 'year'
      }
    end

    it 'fails with a single message' do
      expect(application.errors.count).to eql 1
      expect(application.errors[:declaration]).to eql(['must be "Natalie Zurbman"'])
    end

    context 'the declaration is provided' do
      before { application.declaration = 'Natalie Zurbman' }

      it { is_expected.to be_valid }
    end
  end
end
