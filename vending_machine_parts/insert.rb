class Insert
  attr_reader :slot_money
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @slot_money = 0
    # @salse_management = SalseManagement.new
  end
<<<<<<< HEAD
  def money_judgement(value)
=======
  def money_judgement(value) 
>>>>>>> 739feecab2b46d7fb284d218ed946cdcff288b14
    MONEY.include?(value)
    #   @slot_money += value
    # else
    #   return value
    # end
  end
  def money_increase(value)
    @slot_money += value
  end
  def money_decrease(value)
    @slot_money -= value
  end
  # def money_amount
  #   @slot_money += value(money_increase - money_decrease)
  #   # @salse_management.proceeds
  # end
  # def slot_money
  #   print @slot_money
  # end
<<<<<<< HEAD
end
=======
end
>>>>>>> 739feecab2b46d7fb284d218ed946cdcff288b14
