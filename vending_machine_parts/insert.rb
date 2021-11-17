class Insert
  attr_reader :slot_money
  MONEY = [10, 50, 100, 500, 1000].freeze

  def initialize
    @slot_money = 0
  end

  def money_judgement(value)
    MONEY.include?(value)
  end

  def money_increase(value)
    @slot_money += value
  end

  def money_decrease(value)
    if value <= @slot_money
      @slot_money -= value
    else
      false
    end
  end
end
