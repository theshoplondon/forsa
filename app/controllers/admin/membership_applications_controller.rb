require 'csv'

class Admin::MembershipApplicationsController < ApplicationController
  def index
    @membership_applications = MembershipApplication.signed.order(updated_at: :desc)

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
      format.csv do
        csv = CSV.generate(headers: true) do |csv|
          csv << MembershipApplication.csv_header
          @membership_applications.each { |appl| csv << appl.attributes }
        end

        send_data csv, filename: "membership-applications-#{Date.today}.csv"
      end
    end
  end

  private

  def date_range_params
    params.permit(:from_date, :to_date)
  end
end
