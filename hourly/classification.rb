# frozen_string_literal: true

# Models the Hourly Payment
module Hourly
  Classification = ImmutableStruct.new(:rate) do
    def timecards
      @timecards ||= {}
    end

    def time_card(date)
      timecards[date]
    end

    def add_time_card(time_card)
      timecards[time_card.date] = time_card
    end

    # rubocop:disable Metrics/AbcSize
    def calculate_pay(pay_check)
      date_range = ((pay_check.pay_date - 6)..(pay_check.pay_date))
      time_cards_for_period = timecards.select do |date, _time_card|
        date_range.member? date
      end.values

      hours_for_period = time_cards_for_period.inject(0) do |sum, time_card|
        overtime_hours = [time_card.hours - 8, 0].max
        normal_hours = time_card.hours - overtime_hours
        sum + normal_hours + overtime_hours * 1.5
      end

      hours_for_period * rate
    end
  end
end
