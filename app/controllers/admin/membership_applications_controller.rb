class Admin::MembershipApplicationsController < ApplicationController
  def index
    @membership_applications = MembershipApplication.signed

    @date_range_params = date_range_params
    @range_query = View::DateRangeQuery.new(@date_range_params)
    if @range_query.present? && @range_query.valid?
      @membership_applications = @membership_applications.merge(MembershipApplication.where(updated_at: @range_query.range))
    end

    respond_to do |format|
      format.html { render }
      format.json do
        render status: 400, json: { errors: @range_query.errors } and return unless @range_query.valid?
        render json: @membership_applications
      end
    end
  end

  private

  def date_range_params
    params.permit(:from_date, :to_date)
  end
end
