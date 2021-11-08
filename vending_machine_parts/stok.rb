class Stock
  atter_reader :stock_count, :drink_stock
  def initialize(count) #自販機の箱（ボタン）の数を引数として取り込み、データ型：integer 入力制限：1 ~ 20
    #配列内配列
    @stock_count = count
    @drink_stock = {}
    n = 65
    count.times{
      @drink_stock[n.chr.to_sym] = []
      n +=1
    }
    #{A: [001, 5], B: [002, 8] }
    drink_addition(:A, :d001, 5)
  end
  def drink_addition(stock_position, drink_number, count) # 引数のデータ型（symbol, symbol, integer）
    if @drink_stock[stock_position]
      @drink_stock[stock_position] = [drink_number, count] # 既存の値があっても上書きになります。
    else
      return false
    end
  end
  def drink_increase(stock_position, count) # 引数のデータ型:(symbol, integer)
    if @drink_stock[stock_position][1] >= 0 && @drink_stock[stock_position]
      @drink_stock[stock_position][1] += count
    else
      return false
    end
  end
  def drink_decrease(stock_position, count) # 引数のデータ型:(symbol, integer)
    if @drink_stock[stock_position][1] >= 1 && @drink_stock[stock_position]
      @drink_stock[stock_position][1] -= count
    else
      return false
    end
  end
  def drink_delete(stock_position)
    if @drink_stock[stock_position]
      @drink_stock[stock_position] == []
    else
      return false
    end
  end
  def drink_buyable_judgement(stock_position, drink_data, slot_money) # 引数を追加しました! データ型：(symbol, hash *@priduct.drink_data, integer *@insert.slot_money  )
    if @drink_stock[stock_position]
      case @drink_stock[stock_position][1]
      when nil
        return 4
      when 0
        return 3
      else
        if drink_data[@drink_stock[stock_position][0]][:price] <= slot_money
          return 1
        else
          return 2
        end
      end
    else
      return false
    end
  #期待する戻り値　1or2or3or4
  #1:購入可能
  #2:お金不足
  #3:品切れ
  #4:商品が存在しない(未設定)
  end
  def drink_list_creation(drink_data, slot_money)
    drink_list = []
    @drink_stock.each do |key, value|
      drink_box = []
      drink_box[0] = key
      drink_box[1] = drink_buyable_judgement(key, drink_data, slot_money)
      if drink_box[1] == 1 ||  drink_box[1] == 2 ||  drink_box[1] == 3
        drink_box[2] = drink_data[value[0]][:name]
        drink_box[3] = drink_data[value[0]][:price]
        drink_box[4] = value[1]
      else
        drink_box[2] = nil
        drink_box[3] = nil
        drink_box[4] = nil
      end
      drink_list << drink_box
    end
    # [[:A, 1,  "コーラ", 120, 15]...]
    # "[A] [購入可能] 商品名：コーラ　値段：120円"
    drink_list.each do |position, status, name, price, count|
      msg = ""
      case status
      when 1
        msg = "購入可能"
      when 2
        msg = "お金不足"
      when 3
        msg = "品切れ　"
      when 4
        msg = "販売中止"
      else
        msg = "エラー　"
      end
      puts "[#{position.to_s} #{msg}] 商品名：「#{name}」 価格：#{price}円 数量：#{count}本 "
    end
  end
end

# drink_data = {:d001=>{:name=>"コーラ", :price=>120}, :d002=>{:name=>"水", :price=>100}, :d003=>{:name=>"レッドブル", :price=>200}}

# st = Stock.new(10)

# st.drink_addition(:B, :d002, 5)

# st.drink_addition(:C, :d003, 5)

# st.drink_increase(:A, 3)

# st.drink_decrease(:B, 4)

# st.drink_decrease(:C, 5)

# p "jage test"

# p st.drink_buyable_judgement(:A, drink_data, 150)

# p st.drink_buyable_judgement(:A, drink_data, 50)

# p st.drink_buyable_judgement(:C, drink_data, 150)

# p st.drink_buyable_judgement(:D, drink_data, 150)

# p "test list"

# st.drink_list_creation(drink_data, 150)
