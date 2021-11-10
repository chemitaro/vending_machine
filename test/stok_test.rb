require 'minitest/autorun'
require '../vending_machine_parts/stok.rb'

class StokTest < Minitest::Test
  def setup
    stok = Stok.new(10)
    drink_data = {:d001=>{:name=>"コーラ", :price=>120}, :d002=>{:name=>"水", :price=>100}, :d003=>{:name=>"レッドブル", :price=>200}}
  end
  def test_sample
    assert_equal 'a', 'a'
  end
  def test_initialize
    assert_equal stok, 'a'
    
  end
end