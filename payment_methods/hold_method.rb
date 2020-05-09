# frozen_string_literal: true

# Models A Hold Payment Method
class HoldMethod
  def disposition
    'Hold'
  end

  def pay(pay_check)
    pay_check.to_s
  end
end
