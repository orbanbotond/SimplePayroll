class UnionAffiliation
  attr_reader :dues, :memberId

  def initialize(memberId, dues)
    @service_charges = {}
    @dues = dues
    @memberId = memberId
  end

  def get_service_charge(date)
    @service_charges[date]
  end

  def add_service_charge(service_charge)
    @service_charges[service_charge.date] = service_charge
  end

  def calculate_deductions(paycheck)
    fridays = 0
    ((paycheck.start_date)..(paycheck.pay_date)).each do |date|
      fridays += 1 if date.friday?
    end

    charges = 0
    service_charges = @service_charges.values.each do |service_charge|
      if service_charge.date >= paycheck.start_date and service_charge.date <= paycheck.pay_date
        charges += service_charge.charge
      end
    end

    @dues * fridays + charges
  end
end
