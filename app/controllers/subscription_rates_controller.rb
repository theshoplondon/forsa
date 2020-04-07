class SubscriptionRatesController < ApplicationController
  rescue_from(ActionController::UnknownFormat) { head 406 }
  rescue_from(ArgumentError)                   { |e| render status: 400, json: { error: e } }

  def show
    respond_to do |format|
      format.json do
        rate = SubscriptionRate.new(params[:pay_rate], params[:pay_unit], params[:hours_per_week])
        render json: { 'monthly_estimate' => rate.monthly_estimate }
      end
    end
  end
end
