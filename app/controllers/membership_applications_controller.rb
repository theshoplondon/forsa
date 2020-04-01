class MembershipApplicationsController < ApplicationController
  def create
    @membership_application = MembershipApplication.new(membership_application_params)

    if @membership_application.save
      session[:member_id] = @member.to_param
      redirect_to '/'
    else
      render :new
    end
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
