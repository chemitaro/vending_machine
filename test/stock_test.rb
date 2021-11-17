require 'minitest/autorun'
require '../vending_machine_parts/stock.rb'

class StockTest < Minitest::Test
  def setup
    @drink_data = {:d001=>{:name=>"コーラ", :price=>120}, :d002=>{:name=>"水", :price=>100}, :d003=>{:name=>"レッドブル", :price=>200}}
    @stock = Stock.new(10)
  end
  def test_drink_stock
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_stock_count
    assert_equal @stock.stock_count, 10
  end
  def test_drink_addition
    @stock.drink_addition(:B, :d002, 5)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[:d002, 5], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_addition_false
    refute @stock.drink_addition(:Z, :d002, 5)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_addition_same_stock
    @stock.drink_addition(:A, :d002, 5)
    assert_equal @stock.drink_stock, {:A=>[:d002, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_increase
    @stock.drink_increase(:A, 1)
    assert_equal @stock.drink_stock, {:A=>[:d001, 6], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_increase_false_1
    refute @stock.drink_increase(:B, 1)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_increase_false_2
    refute @stock.drink_increase(:Z, 1)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_decrease
    @stock.drink_decrease(:A, 1)
    assert_equal @stock.drink_stock, {:A=>[:d001, 4], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_decrease_over
    refute @stock.drink_decrease(:A, 6)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_decrease_false
    refute @stock.drink_decrease(:B, 1)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_decrease_false
    refute @stock.drink_decrease(:Z, 1)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_delete
    @stock.drink_delete(:A)
    assert_equal @stock.drink_stock, {:A=>[], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_delete_false_1
    @stock.drink_delete(:B)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_delete_false_2
    refute @stock.drink_delete(:Z)
    assert_equal @stock.drink_stock, {:A=>[:d001, 5], :B=>[], :C=>[], :D=>[], :E=>[], :F=>[], :G=>[], :H=>[], :I=>[], :J=>[]}
  end
  def test_drink_buyable_judgement_1
    assert_equal @stock.drink_buyable_judgement(:A, @drink_data, 200), 1
  end
  def test_drink_buyable_judgement_2
    assert_equal @stock.drink_buyable_judgement(:A, @drink_data, 50), 2
  end
  def test_drink_buyable_judgement_3
    @stock.drink_decrease(:A, 5)
    assert_equal @stock.drink_buyable_judgement(:A, @drink_data, 200), 3
  end
  def test_drink_buyable_judgement_4
    assert_equal @stock.drink_buyable_judgement(:B, @drink_data, 200), 4
  end
  def test_drink_buyable_judgement_false
    assert_equal @stock.drink_buyable_judgement(:Z, @drink_data, 200), false
  end
  def test_drink_list_creation_1
    assert_equal @stock.drink_list_creation(@drink_data, 500), [[:A, 1, "コーラ", 120, 5], [:B, 4, nil, nil, nil], [:C, 4, nil, nil, nil], [:D, 4, nil, nil, nil], [:E, 4, nil, nil, nil], [:F, 4, nil, nil, nil], [:G, 4, nil, nil, nil], [:H, 4, nil, nil, nil], [:I, 4, nil, nil, nil], [:J, 4, nil, nil, nil]]
  end
  def test_drink_list_creation_2
    assert_equal @stock.drink_list_creation(@drink_data, 50), [[:A, 2, "コーラ", 120, 5], [:B, 4, nil, nil, nil], [:C, 4, nil, nil, nil], [:D, 4, nil, nil, nil], [:E, 4, nil, nil, nil], [:F, 4, nil, nil, nil], [:G, 4, nil, nil, nil], [:H, 4, nil, nil, nil], [:I, 4, nil, nil, nil], [:J, 4, nil, nil, nil]]
  end
  def test_drink_name
    assert_equal @stock.drink_name(:A, @drink_data), "コーラ"
  end
  def test_drink_price
    assert_equal @stock.drink_price(:A, @drink_data), 120
  end
  def test_stock_position_condition_1
    assert_equal @stock.stock_position_condition(:A), 1
  end
  def test_stock_position_condition_2
    @stock.drink_decrease(:A, 5)
    assert_equal @stock.stock_position_condition(:A), 2
  end
  def test_stock_position_condition_3
    assert_equal @stock.stock_position_condition(:B), 3
  end
  def test_stock_position_condition_false
    assert_equal @stock.stock_position_condition(:Z), false
  end




end
