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
  end

  private

  def membership_application_params
    params.require(:membership_application)
      .permit(
        :first_name,
        :email
      )
  end
end
