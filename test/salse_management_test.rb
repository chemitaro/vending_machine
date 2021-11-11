require 'minitest/autorun'
require '../vending_machine_parts/salse_management.rb'

class SalseManagementTest < Minitest::Test
  def setup
    @salse_management = SalesManagement.new
  end
  def test_proceeds
    assert_equal @salse_management.proceeds, 0
  end
  def test_proceeds_increase
    @salse_management.proceeds_increase(100)
    assert_equal @salse_management.proceeds, 100
  end
  def test_proceeds_decrease
    @salse_management.proceeds_increase(500)
    @salse_management.proceeds_decrease(100)
    assert_equal @salse_management.proceeds, 400
  end
  def test_proceeds_decrease_false
    @salse_management.proceeds_increase(100)
    refute @salse_management.proceeds_decrease(500)
    assert_equal @salse_management.proceeds, 100
  end



end