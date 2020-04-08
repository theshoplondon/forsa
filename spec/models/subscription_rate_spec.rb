require 'rails_helper'

RSpec.describe SubscriptionRate do
  subject(:rate) { SubscriptionRate.new(pay_rate, pay_unit, hours_per_week) }

  let(:hours_per_week) { nil } # Not ordinarily required

  describe '#monthly_estimate' do
    context 'annual salary' do
      let(:pay_unit) { 'year' }

      context 'below cap' do
        let(:pay_rate) { '18000' }

        it 'calculates the rate as fixed 0.8% of annual earnings' do
          expect(rate.monthly_estimate).to eql('12.00') # (18000 * 0.8/100) / 12
        end
      end

      context 'capped' do
        let(:pay_rate) { '80000' }

        it 'calculates the rate as a fixed 0.8% of the annual cap' do
          expect(rate.monthly_estimate).to eql('32.30')
        end
      end
    end

    context 'monthly pay' do
      let(:pay_unit) { 'month' }

      context 'below cap' do
        let(:pay_rate) { '1500' }

        it 'calculates the rate as fixed 0.8% of an assumed 12-month annual salary' do
          expect(rate.monthly_estimate).to eql('12.00')
        end
      end

      context 'above cap' do
        let(:pay_rate) { '4200' }

        it 'calculates the rate as fixed 0.8% of an assumed 12-month annual salary' do
          expect(rate.monthly_estimate).to eql('32.30')
        end
      end
    end

    context 'weekly pay' do
      let(:pay_unit) { 'week' }
      let(:pay_rate) { '350' }

      it 'calculates the rate as fixed 0.8% of an assumed 52-week annual salary' do
        expect(rate.monthly_estimate).to eql('12.13')
      end
    end

    context 'hourly pay' do
      let(:pay_unit) { 'hour' }
      let(:pay_rate) { '15.50' }

      context 'no hours_per_week were assigned' do
        it 'raises an ArgumentError' do
          expect { SubscriptionRate.new(pay_rate, pay_unit, nil) }.to raise_error(
            ArgumentError, /pay_unit of 'hour' given, hours_per_week required/
          )
        end
      end

      context 'hours_per_week was blank' do
        it 'raises an ArgumentError' do
          expect { SubscriptionRate.new(pay_rate, pay_unit, '') }.to raise_error(
            ArgumentError, /pay_unit of 'hour' given, hours_per_week required/
          )
        end
      end

      context 'hours_per_week are given' do
        let(:hours_per_week) { 30 }

        context 'below cap' do
          it 'calculates the rate as fixed 0.8% of an assumed 52-week annual salary' do
            expect(rate.monthly_estimate).to eql('16.12')
          end
        end

        context 'capped' do
          let(:pay_rate) { '200.00' }

          it 'hits the cap' do
            expect(rate.monthly_estimate).to eql('32.30')
          end
        end
      end
    end
  end
end
