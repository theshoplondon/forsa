require 'rails_helper'

RSpec.describe '/admin/membership-applications as JSON', type: :request do
  include TokenAuthenticationHelpers

  let(:params)  { { } }
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
    let!(:signed_applications) do
      create_list :membership_application, 2, :step_declaration, employer: 'Lastweek', updated_at: 1.week.ago
      create_list :membership_application, 2, :step_declaration, employer: 'Today', updated_at: Date.today
    end
    let!(:incomplete_applications) do
      create_list :membership_application, 2, :step_about_you, employer: 'Lastweek', updated_at: 1.week.ago
      create_list :membership_application, 2, :step_about_you, employer: 'Today', updated_at: Date.today
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

    context 'date params are given' do
      it 'restricts applications to those in date range'
    end
  end
end
