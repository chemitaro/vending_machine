require 'minitest/autorun'
require '../vending_machine.rb'

class ProductTest < Minitest::Test
  def setup
    @vm = VendingMachine.new
  end
end
