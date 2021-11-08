class SalesManagement
  attr_reader :proceeds
  def initialize
    @proceeds = 0
  end
  def proceeds_increase(value)
    @proceeds += value
  end
  def proceeds_decrease(value)
    @slot_money -= value
  end
end
