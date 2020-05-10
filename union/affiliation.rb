# frozen_string_literal: true

# Models the UnionAffiliation
module Union
  Affiliation = ImmutableStruct.new(:member_id, :dues) do
    def service_charges
      @service_charges ||= {}
    end

    def service_charge(date)
      service_charges[date]
    end

    def add_service_charge(service_charge)
      service_charges[service_charge.date] = service_charge
    end

    def calculate_deductions(paycheck)
      deductable_charges = service_charges.values.filter { |charge| (charge.date >= paycheck.start_date) && (charge.date <= paycheck.pay_date) }
      charges = deductable_charges.inject(0) { |sum, service_charge| sum + service_charge.charge }

      dues * fridays(paycheck) + charges
    end

    private

    def fridays(paycheck)
      ((paycheck.start_date)..(paycheck.pay_date)).select(&:friday?).count
    end
  end
end
