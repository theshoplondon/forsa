##
# This controller only creates new applications and shows completed ones.
# The building up of the application happens in +StepsController+.
class MembershipApplicationsController < ApplicationController
  def create
    @membership_application = MembershipApplication.new(membership_application_params)

    if @membership_application.save
      session[:membership_application_id] = @membership_application.to_param
      redirect_to membership_application_step_path('about-you')
    else
      render :new
    end
  end

  def completed
    @membership_application = current_membership_application if session[:membership_application_id]
  end

  def update
    current_membership_application.update(membership_application_params.merge(answered_post_join: true))
    redirect_to completed_membership_application_path

    # The post-join questions are done; no more interaction with the application
    session.delete(:membership_application_id)
  end

  private

  def current_membership_application
    MembershipApplication.find(session[:membership_application_id])
  end

  def membership_application_params
    params.require(:membership_application)
      .permit(
        :first_name,
        :email,
        :previous_union,
        :income_protection
    )
  end
end
