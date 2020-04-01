module MembershipApplications
  ##
  # Given a started application from +MembershipApplicationsController+,
  # build its values up through the steps.
  class StepsController < ApplicationController
    include Wicked::Wizard

    steps :about_you

    def show
      @membership_application = current_membership_application
      render_wizard
    end

    def update
      @membership_application = current_membership_application
      @membership_application.assign_attributes(step_params)

      render_wizard(@membership_application)
    end

    private

    def current_membership_application
      MembershipApplication.find(session[:membership_application_id])
    end

    def finish_wizard_path
      completed_membership_application_path
    end

    def step_params
      params.require(:membership_application)
        .permit(:first_name, :last_name, :email, :date_of_birth)
    end
  end
end
