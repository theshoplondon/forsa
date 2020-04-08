class SubscriptionRate
  FIXED_PERCENTAGE = (0.8).freeze
  ANNUAL_CAP       = 48450.freeze

  DEEMED_WEEKS     = 52.freeze
  DEEMED_MONTHS    = 12.freeze

  attr_accessor :pay_rate, :pay_unit, :hours_per_week

  def initialize(pay_rate, pay_unit, hours_per_week = nil)
    raise ArgumentError, 'pay_rate is required' if pay_rate.nil?
    raise ArgumentError, 'pay_unit is required' if pay_unit.nil?
    raise ArgumentError, "pay_unit of 'hour' given, hours_per_week required" if
      pay_unit == 'hour' && hours_per_week.blank?

    self.pay_rate = BigDecimal(pay_rate)
    self.pay_unit = pay_unit
    self.hours_per_week = BigDecimal(hours_per_week) if pay_unit == 'hour'
  end

  ##
  # Return the monthly estimate as a formatted string
  def monthly_estimate
    '%0.2f' % monthly
  end

  def capped_annual_pay
    [annualised_pay_rate, ANNUAL_CAP].min
  end

  def annualised_pay_rate
    case pay_unit
    when 'year' then pay_rate
    when 'month' then pay_rate * DEEMED_MONTHS
    when 'week' then pay_rate * DEEMED_WEEKS
    when 'hour' then pay_rate * hours_per_week * DEEMED_WEEKS
    else
      raise ArgumentError, "#{pay_unit.class} #{pay_unit} is not a valid pay_unit"
    end
  end

  ##
  # Monthly estimate as a decimal
  def monthly
    (capped_annual_pay * FIXED_PERCENTAGE / 100) / 12
  end
end
