require "rails_helper"

RSpec.describe MembershipApplications::StepsController, type: :controller do
  let(:membership_application) do
    MembershipApplication.create(
      current_step: 'contact-details',
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
    )
  end

  before do
    session[:membership_application_id] = membership_application.id

    put :update,
      params: {
        id: 'declaration',
        membership_application: { declaration: declaration }
      }

    membership_application.reload
  end

  context 'the declaration is fine' do
    let(:declaration) { 'Natalie Zurbman' }
    it 'completes the application by setting current_step to declaration' do
      expect(membership_application.current_step).to eql('declaration')
    end
  end

  context 'the declaration is not correct' do
    let(:declaration) { 'Notolyu Zarbmen' }
    it 'leaves the application at the contact-details step' do
      expect(membership_application.current_step).to eql('contact-details')
    end
  end
end
