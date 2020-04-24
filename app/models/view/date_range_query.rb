module View
  class DateRangeQuery
    include ActiveModel::Model
    include ActiveModel::Attributes

    class DateValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        time_or_date = DateRangeQuery.try_parse_date(value)
        record.errors.add attribute, 'is not a date or date/time' if time_or_date.nil?
      end
    end

    # Attrs as strings so no coercion
    attribute :from_date, :string
    attribute :to_date, :string

    validates :from_date, date: true, allow_blank: true
    validates :to_date, date: true, allow_blank: true

    validate :from_date_less_than_to_date, if: -> { from_date.present? && to_date.present? }

    def initialize(params)
      @params = params
      super(params)
    end

    def inspect
      "from_date: #{from_date.class}: #{from_date}, to_date: #{to_date.class}: #{to_date}"
    end

    def empty?
      from_date.blank? && to_date.blank?
    end

    def present?
      !empty?
    end

    def range
      DateRangeQuery.try_parse_date(from_date)..DateRangeQuery.try_parse_date(to_date)
    end

    def scope
      MembershipApplication.where(updated_at: range)
    end

    def self.try_parse_date(value)
      (Time.zone.parse(value) rescue nil) || (Date.parse(value) rescue nil)
    end

    private

    def from_date_less_than_to_date
      errors[:from_date] << 'from date is after to date' if from_date > to_date
    end
  end
end
