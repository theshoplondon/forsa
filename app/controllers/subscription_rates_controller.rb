class SubscriptionRatesController < ApplicationController
  rescue_from(ActionController::UnknownFormat) { head 406 }
  rescue_from(ArgumentError)                   { |e| render status: 400, json: { error: e } }

  def show
    respond_to do |format|
      format.json do
        rate = SubscriptionRate.new(
          params[:pay_rate],
          params[:pay_unit],
          hours_per_week: params[:hours_per_week],
          clerical_rate: params[:clerical_rate]&.strip == 'true'
        )
        render json: {
          'monthly_estimate' => rate.monthly_estimate,
          'percentage' => rate.percentage
        }
      end
    end
  end
end
