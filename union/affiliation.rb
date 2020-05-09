# frozen_string_literal: true

# Models the UnionAffiliation
module Union
  Affiliation = ImmutableStruct.new(:member_id, :dues) do
    def service_charges
      @service_charges ||= {}
    end

    # TODO: change this to service_charge
    def service_charge(date)
      service_charges[date]
    end

    def add_service_charge(service_charge)
      service_charges[service_charge.date] = service_charge
    end

    def calculate_deductions(paycheck)
      charges = 0
      service_charges.values.each do |service_charge|
        if (service_charge.date >= paycheck.start_date) && (service_charge.date <= paycheck.pay_date)
          charges += service_charge.charge
        end
      end

      dues * fridays(paycheck) + charges
    end

    private

    def fridays(paycheck)
      ((paycheck.start_date)..(paycheck.pay_date)).select(&:friday?).count
    end
  end
end
