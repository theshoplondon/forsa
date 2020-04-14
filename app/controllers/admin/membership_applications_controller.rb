class Admin::MembershipApplicationsController < ApplicationController
  def index
    @membership_applications = MembershipApplication.signed

    respond_to do |format|
      format.html { render }
      format.json { render json: @membership_applications }
    end
  end
end
