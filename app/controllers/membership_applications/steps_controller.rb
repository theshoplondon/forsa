module MembershipApplications
  ##
  # Given a started application from +MembershipApplicationsController+,
  # build its values up through the steps.
  class StepsController < ApplicationController
    include Wicked::Wizard

    steps *MembershipApplication::Steps.instance.step_names

    # We only look up one thing in this controller. If
    # it's not there, to the front page we go
    rescue_from ActiveRecord::RecordNotFound do
      redirect_to root_path
    end

    def show
      @membership_application = current_membership_application
      return if redirect_when_complete(@membership_application)

      render_wizard
    end

    def update
      @membership_application = current_membership_application
      @membership_application.current_step = step unless @membership_application.reached_step?(step)
      @membership_application.assign_attributes(step_params)

      render_wizard(@membership_application)

      SubscribeJob.perform_async(@membership_application.id) if @membership_application.completed?
    end

    private

    def current_membership_application
      MembershipApplication.find(session[:membership_application_id])
    end

    def finish_wizard_path
      completed_membership_application_path
    end

    def redirect_when_complete(membership_application)
      redirect_to completed_membership_application_path if membership_application.completed?
    end

    def step_params
      params.require(:membership_application).permit(MembershipApplication::Steps::PARAMS.fetch(step))
    end
  end
end
