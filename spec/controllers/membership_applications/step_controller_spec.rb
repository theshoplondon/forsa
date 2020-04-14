require "rails_helper"

RSpec.describe MembershipApplications::StepsController, type: :controller do
  let(:membership_application) { create :membership_application, :step_work_and_pay }

  describe 'signing the application' do
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
      it 'leaves the application at the work-and-pay step' do
        expect(membership_application.current_step).to eql('work-and-pay')
      end
    end
  end
end
