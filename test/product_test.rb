require 'minitest/autorun'
require '../product.rb'


class ProductTest < Minitest::Test
  def setup
    @product = Product.new
  end
  def test_drink_data
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_drink_data_register
    @product.drink_data_register(:d004, "おしるこ", 150)
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}, d004: {name: "おしるこ", price: 150}}

  end
  def test_drink_data_register_false
    refute @product.drink_data_register(:d001, "おしるこ", 150)
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_change_name
    @product.change_name(:d001, "ペプシ")
    assert_equal @product.drink_data, {d001: {name: "ペプシ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_change_name_false
    refute @product.change_name(:d004, "ペプシ")
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end

  def test_change_price
    @product.change_price(:d001, 500)
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 500}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_change_price_false
    refute @product.change_price(:d004, 500)
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_drink_data_delete
    @product.drink_data_delete(:d001)
    assert_equal @product.drink_data, {d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_drink_data_delete
    refute @product.drink_data_delete(:d004)
    assert_equal @product.drink_data, {d001: {name: "コーラ", price: 120}, d002: {name: "水", price: 100}, d003: {name: "レッドブル", price: 200}}
  end
  def test_number_present?
    assert @product.number_present?(:d001)
  end
  def test_number_present_false
    refute @product.number_present?(:d004)
  end
end
