class Product
  attr_reader :drink_data
  def initialize
    @drink_data = {}
    #{number: { name: name, price: price }}
    drink_data_register(:d001, "コーラ", 120)
    drink_data_register(:d002, "水", 100)
    drink_data_register(:d003, "レッドブル", 200)
  end
  def drink_data_register(number, name, price) # 引数のデータ型　(symbol, string, integer)
    if @drink_data[number]  #上書き防止、すでにナンバーが登録されていたら戻り値としてfalseを返します。
      return false
    else
      @drink_data[number] = {name: name, price: price}
    end
  end
  def change_name(number, name) # 引数のデータ型　(symbol, string)
    if @drink_data[number] # numbreがすでにあるか検索　無ければ、戻り値としてfalseを返します。
      @drink_data[number][:name] = name
    else
      return false
    end
  end
  def change_price(number, price)# 引数のデータ型　(symbol, integer)
    if @drink_data[number] # numbreがすでにあるか検索　無ければ、戻り値としてfalseを返します。
      @drink_data[number][:price] = price
    else
      return false
    end
  end
  def drink_data_delete(number)# 引数のデータ型　(symbol)
    if @drink_data[number] # numbreがすでにあるか検索　無ければ、戻り値としてfalseを返します。
      @drink_data.delete(number)
    else
      return false
    end
  end
end
