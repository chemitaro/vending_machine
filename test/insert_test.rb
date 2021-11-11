require 'minitest/autorun'
require '../vending_machine_parts/insert.rb'

class InsertTest < Minitest::Test
  def setup
    @insert = Insert.new
  end
  def test_slot_money
    assert_equal @insert.slot_money, 0
  end
  def test_money_judgement
    assert @insert.money_judgement(10)
    assert @insert.money_judgement(50)
    assert @insert.money_judgement(100)
    assert @insert.money_judgement(500)
    assert @insert.money_judgement(1000)
    refute @insert.money_judgement(1)
    refute @insert.money_judgement(5)
    refute @insert.money_judgement(2000)
  end
  def test_money_increase
    @insert.money_increase(100)
    assert_equal @insert.slot_money, 100
  end
  def test_money_decrease
    @insert.money_increase(500)
    @insert.money_decrease(100)
    assert_equal @insert.slot_money, 400
  end
  def test_money_decrease_false
    @insert.money_increase(100)
    refute @insert.money_decrease(200)
    assert_equal @insert.slot_money, 100
  end
end