class Stock
  attr_reader :stock_count, :drink_stock

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
    if stock_position_condition(stock_position)
      @drink_stock[stock_position] = [drink_number, count] # 既存の値があっても上書きになります。
    else
      return false
    end
  end

  def drink_increase(stock_position, count) # 引数のデータ型:(symbol, integer)
    if stock_position_condition(stock_position) == 1 || stock_position_condition(stock_position) == 2
      @drink_stock[stock_position][1] += count
    else
      return false
    end
  end

  def drink_decrease(stock_position, count) # 引数のデータ型:(symbol, integer)
    if stock_position_condition(stock_position) == 1 && @drink_stock[stock_position][1] >= count
      @drink_stock[stock_position][1] -= count
    else
      return false
    end
  end

  def drink_delete(stock_position)
    if stock_position_condition(stock_position) == 1 || stock_position_condition(stock_position) == 2
      @drink_stock[stock_position] = []
    else
      return false
    end
  end

  def drink_buyable_judgement(stock_position, drink_data, slot_money) # 引数を追加しました! データ型：(symbol, hash *@priduct.drink_data, integer *@insert.slot_money  )
    if stock_position_condition(stock_position)
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
    drink_list
    # 出力形態 [[:A, 1,  "コーラ", 120, 15]...]
  end

  def drink_name(stock_position, drink_data)
    drink_data[@drink_stock[stock_position][0]][:name]
  end

  def drink_price(stock_position, drink_data)
    drink_data[@drink_stock[stock_position][0]][:price]
  end

  def stock_position_condition(stock_position) #追加メソッド　入力されたstock_positionが存在するか判定 true/false
    if @drink_stock[stock_position].nil?
      false
    else
      case drink_stock[stock_position][1]
      when nil
        return 3
      when 0
        return 2
      when 1..nil
        return 1
      else
        false
      end
    end
    # 1:ドリンクが存在する 1本以上
    # 2:ドリンクが品切れ 0本
    # 3:ドリンクが存在しない, 未設定
    # false:positionが存在しない
  end

  def get_current_number #商品ナンバー一覧を取得
    current_number = []
    @drink_stock.each do |key, value|
      current_number << value[0]
    end
    current_number
  end
end
