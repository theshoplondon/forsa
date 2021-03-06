require 'rails_helper'

RSpec.describe '/admin/membership-applications', type: :request do
  include TokenAuthenticationHelpers

  let(:params)  { {} }

  context 'as JSON' do
    let(:headers) { { 'Accept' => 'application/json' } }


    subject(:json) { JSON.parse(response.body) }

    context 'no credentials are supplied' do
      before do
        get '/admin/membership-applications', params: params, headers: headers
      end

      it '401s with a message' do
        aggregate_failures do
          expect(response.status).to eql(401)
          expect(json).to eql('error' => 'You need to sign in or sign up before continuing.')
        end
      end
    end

    context 'credentials are supplied so we can get by date' do
      let(:old_date) { '2020-04-14 01:00:59' }
      let(:new_date) { '2020-04-15' }

      let!(:signed_applications) do
        create_list :membership_application, 2, :step_declaration, employer: 'Yesterday', updated_at: old_date
        create_list :membership_application, 2, :step_declaration, employer: 'Today', updated_at: new_date
      end
      let!(:incomplete_applications) do
        create_list :membership_application, 2, :step_about_you, employer: 'Yesterday', updated_at: old_date
        create_list :membership_application, 2, :step_about_you, employer: 'Today', updated_at: new_date
      end

      before do
        get '/admin/membership-applications', params: params, headers: headers.merge(make_valid_api_credentials)
      end

      context 'no date params are given' do
        it 'gets all signed applications' do
          expect(MembershipApplication.signed.count).to eql(4)
          expect(json.length).to eql(4)
        end
      end

      context 'invalid date params are given' do
        let(:params) { { from_date: '2021-04-14', to_date: '2020-04-14' } }

        it '400s' do
          aggregate_failures do
            expect(response.status).to eql(400)
            expect(json).to eql('errors' => { 'from_date' => ['from date is after to date'] })
          end
        end
      end

      context 'valid date params are given' do
        let(:params) { { from_date: '2020-04-14', to_date: '2020-04-14 23:59:59' } }

        it 'restricts applications to those in date range' do
          expect(MembershipApplication.signed.count).to eql(4)
          expect(json.length).to eql(2)
          expect(json.map { |item| item['employer'] }).to all(eql('Yesterday'))
        end
      end
    end
  end

  context 'as CSV with a date range' do
    let(:headers) { { 'Accept' => 'text/csv' } }
    let(:params)  { { from_date: '2020-04-14', to_date: '2020-04-14 23:59:59' } }

    let(:old_date) { '2020-04-14 01:00:59' }
    let(:new_date) { '2020-04-15' }

    let!(:signed_applications) do
      create_list :membership_application, 2, :step_declaration, employer: 'Yesterday', updated_at: old_date
      create_list :membership_application, 2, :step_declaration, employer: 'Today', updated_at: new_date
    end
    let!(:incomplete_applications) do
      create_list :membership_application, 2, :step_about_you, employer: 'Yesterday', updated_at: old_date
      create_list :membership_application, 2, :step_about_you, employer: 'Today', updated_at: new_date
    end

    subject(:rows) { CSV.parse(response.body, headers: true) }

    before do
      get '/admin/membership-applications', params: params, headers: headers.merge(make_valid_api_credentials)
    end

    it 'parsed rows with the header excluding fields we don\'t care about' do
      application = rows.first

      expect(application).to have_key('id')
      expect(application).to have_key('first_name')
      expect(application).not_to have_key('dropped_cart_resumption_token')
    end

    it 'only has signed rows in date range' do
      expect(rows.length).to eql(2)
      expect(rows).to all(satisfy { |r| r['completed'] == 'true' } )
    end
  end
end
