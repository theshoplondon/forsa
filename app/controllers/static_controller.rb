class StaticController < ApplicationController
  def home
    @membership_application = MembershipApplication.new
    render 'membership_applications/new'
  end
end
