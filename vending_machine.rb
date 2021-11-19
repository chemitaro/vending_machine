#irb
#load './vending_machine.rb'
#vm = VendingMachine.new

require './product'
require './vending_machine_parts/insert'
require './vending_machine_parts/stock'
require './vending_machine_parts/salse_management'
require './vending_machine_parts/mony_management'
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
class VendingMachine

  def initialize
    @product = Product.new
    @insert = Insert.new
    @salse_management = SalesManagement.new
    slot_number = 0
    loop {
      puts "自動販売機のスロット数を半角数字で入力して下さい"
      slot_number = gets.chomp
      if slot_number =~ /^\d+$/ && slot_number.to_i > 0
        slot_number = slot_number.to_i
        break
      else
        puts "有効な数字を入力して下さい"
        next
      end
    }
    @stock = Stock.new(slot_number) #引数でVMの商品スロット数を指定
    @my_orders = [] #購入品を格納する配列
    mode_selection #初期モードへ移行
  end

  def mode_selection #各モードを選択
    loop {
      puts "\nモード選択"
      puts "任意の数字を入力してエンターキーを押して下さい"
      puts "sales_mode：1"
      puts "admin_mode：2"
      puts "product_db_mode：3"
      puts "プログラム終了：4"

      user_input = gets.chomp

      if user_input =~ /^[1-4]$/
        user_input = user_input.to_i
      else
        puts "有効な半角数字を入力して下さい"
        next
      end

      case user_input
      when 1
        sales_mode
      when 2
        admin_mode
      when 3
        product_db_mode
      when 4
        break
      else
        puts "有効な入力では有りません"
      end
    }
  end

  def sales_mode #商品購入モード
    information = "\nいらっしゃいませ！"
    loop {
      puts "\n\n\n\n------------------------------------------------------------------------"
      puts "---------------------------自動販売機-----------------------------------"
      puts "------------------------------------------------------------------------"
      vm_info_display("sales") #salesモードの商品表示
      puts "------------------------------------------------------------------------"
      puts "投入残金額:#{@insert.slot_money}円"
      if @my_orders.length == 0 #購入品の出力
        puts "購入品：なし"
      else
        puts "購入品：#{@my_orders.join(',')}"
      end
      puts "--------------------------information display---------------------------"
      puts information
      puts "\n------------------------------------------------------------------------"
      puts "\n使用方法"
      puts "以下の任意の文字又は数字を入力し、エンターキーを押して下さい"
      puts "お金の投入：任意の金額を半角数字　例.100円を投入するときは 100"
      puts "商品購入:商品ボタンの半角アルファベット　例：A"
      puts "投入金の返金：refund"
      puts "買い物を終了：end"

      user_input = gets.chomp

      case user_input
      when /^\d+$/
        information = deposit(user_input) #入金処理
      when "refund"
        information = return_money #返金処理
      when /^[A-Z]$/
        information = push_button(user_input) #購入処理
      when "end"
        break
      else
        information = "\n有効な入力では有りません"
      end
    }
  end

  def admin_mode #管理者モード
    information = "\n自動販売機管理モード中"
    loop {
      puts "\n\n\n\n---------------------------自動販売機-----------------------------------"
      vm_info_display("admin") #adminモードのの商品表示
      puts "------------------------------------------------------------------------"
      puts "自動販売機内金額：#{@salse_management.proceeds}円"
      puts "------------------------------------------------------------------------"
      puts "\n\n----------------------------商品情報------------------------------------"
      product_info_display #データベースの商品情報
      puts "--------------------------information display---------------------------"
      puts information
      puts "\n------------------------------------------------------------------------"
      puts "\n任意の数字を入力してエンターキーを押して下さい"
      puts "自販機への商品割当：1"
      puts "自販機商品の本数補充：2"
      puts "自販機商品の本数を減らす：3"
      puts "自販機商品の削除：4"
      puts "売上金の回収：5"
      puts "管理モードの終了：6"

      user_input = gets.chomp

      if user_input =~ /^[1-6]$/
        user_input = user_input.to_i
      else
        information = "\n有効な半角数字を入力して下さい"
        next
      end

      case user_input
      when 1
        information = vm_drink_allocation #商品割当
      when 2
        information = vm_drink_increase #商品個数追加
      when 3
        information = vm_drink_decrease #商品個数削減
      when 4
        information = vm_drink_deleate #商品削除
      when 5
        information = vm_proceeds_decrease #売上金の回収
      when 6
        break
      else
        information = "\n有効な入力では有りません"
      end
    }
  end

  def product_db_mode
    information = "\n商品情報管理モード中"
    loop {
      puts "\n\n\n\n----------------------------商品情報------------------------------------"
      product_info_display #商品情報
      puts "--------------------------information display---------------------------"
      puts information
      puts "\n------------------------------------------------------------------------"
      puts "\商品情報管理モード"
      puts "任意の数字を入力してエンターキーを押して下さい"
      puts "商品の登録：1"
      puts "商品名の変更：2"
      puts "値段の変更：3"
      puts "商品の登録削除：4"
      puts "管理モードの終了：5"

      user_input = gets.chomp

      if user_input =~ /^[1-5]$/
        user_input = user_input.to_i
      else
        information = "\n有効な半角数字を入力して下さい"
        next
      end

      case user_input
      when 1
        information = db_drink_data_register #商品登録
      when 2
        information = db_change_name #商品名変更
      when 3
        information = db_change_price #商品値段変更
      when 4
        information = db_drink_data_delete #商品登録情報削除
      when 5
        break
      else
        information = "\n有効な入力では有りません"
      end
    }
  end
  #-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  def vm_info_display(user) #自販機内の商品情報出力
    drink_data = @product.drink_data
    slot_money = @insert.slot_money
    drink_list = @stock.drink_list_creation(drink_data, slot_money)

    case user
    when "sales"
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
          msg = "販売停止中"
          puts "#{position.to_s} [#{msg}]"
          next
        else
          msg = "エラー　"
        end
        puts "#{position.to_s} [#{msg}] 商品名:#{name} 価格：#{price}円 数量：#{count}本 "
      end
    when "admin"
      drink_list.each do |position, status, name, price, count|
        puts "#{position.to_s} 商品名:#{name} 価格：#{price}円 数量：#{count}本 "
      end
    end
  end

  def product_info_display #登録されている商品情報の表示
    drink_data = @product.drink_data
    drink_data.each{ |number, name_price|
      puts "\n商品番号：#{number}　商品名：#{name_price[:name]}　値段：#{name_price[:price]}"
    }
  end

  def deposit(money) #投入されたお金が使用できるか判断
    money = money.to_i
    if @insert.money_judgement(money)
      @insert.money_increase(money)
      "\n#{money}円を投入しました"
    else
      "\n有効な貨幣では有りません、以下の貨幣が使用できます\n硬貨:10円, 50円, 100円, 500円\n紙幣:1000円\n#{money}円を返却しました"
    end
  end

  def return_money #返金処理
    text = "\n#{@insert.slot_money}円を返却しました"
    @insert.money_decrease(@insert.slot_money)
    text
  end

  def push_button(stock_position) #購入処理
    stock_position = stock_position.to_sym
    puts "開始"
    case @stock.drink_buyable_judgement(stock_position, @product.drink_data, @insert.slot_money)
    when 1
      @stock.drink_decrease(stock_position, 1)
      price = @stock.drink_price(stock_position, @product.drink_data)
      @insert.money_decrease(price)
      @salse_management.proceeds_increase(price)
      @my_orders << "#{@stock.drink_name(stock_position, @product.drink_data)}"
      "\nガコン！　#{@stock.drink_name(stock_position, @product.drink_data)}を購入しました" + return_money
    when 2
      "\n投入代金が不足しています"
    when 3
      "\n申し訳有りません、商品が品切れ中です"
    when 4
      "\n販売を停止しています、有効なアルファベットを入力して下さい"
    else
      "\n存在しない商品ボタンです"
    end
  end
  #-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  def vm_drink_allocation #自販機への商品割当
    drink_data = @product.drink_data
    stock_position = ""
    drink_number = ""
    count = ""
    loop {
      puts "割り当てる自販機ボタンのアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      stock_position = gets.chomp

      if stock_position == "end"
        return "\n入力を終了しました"
      elsif stock_position !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      stock_position = stock_position.to_sym

      puts "商品番号を入力して下さい 例：d001"
      drink_number = gets.chomp
      if drink_number !~ /^d\d{3}$/ || @product.number_present?(drink_number.to_sym) == false
        puts "有効な入力情報では有りません"
        next
      end

      drink_number = drink_number.to_sym

      puts "補充する本数を半角数字で入力して下さい"
      count = gets.chomp
      if count !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      count = count.to_i
      break
    }

    if @stock.drink_addition(stock_position, drink_number, count) == false
      "\n指定された商品スロットは存在しません"
    else
      "\n#{stock_position.to_s}へ#{drink_number.to_s}を#{count}本割り当てました"
    end
  end

  def vm_drink_increase #自販機の商品補充
    stock_position = ""
    count = ""
    loop {
      puts "補充する商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      stock_position = gets.chomp

      if stock_position == "end"
        return "\n入力を終了しました"
      elsif stock_position !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      stock_position = stock_position.to_sym
      puts "補充する本数を半角数字で入力して下さい"

      count = gets.chomp

      if count !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end

      count = count.to_i
      break
    }
    if @stock.drink_increase(stock_position, count) == false
      "\n有効な入力では有りません"
    else
      "\n#{stock_position.to_s}の商品を#{count}本追加しました"
    end
  end

  def vm_drink_decrease#自販機の商品を削減
    stock_position = ""
    count = ""
    loop {
      puts "本数を減らす商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      stock_position = gets.chomp

      if stock_position == "end"
        return "\n入力を終了しました"
      elsif stock_position !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      stock_position = stock_position.to_sym
      puts "減らす本数を半角数字で入力して下さい"
      count = gets.chomp

      if count !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      count = count.to_i
      break
    }
    if @stock.drink_decrease(stock_position, count) == false
      "\n有効な入力では有りません"
    else
      "\n#{stock_position.to_s}の商品を#{count}本減らしました"
    end
  end

  def vm_drink_deleate #自販機の商品の削除
    stock_position = ""
    loop {
      puts "削除する商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      stock_position = gets.chomp

      if stock_position == "end"
        return "\n入力を終了しました"
      elsif stock_position !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      stock_position = stock_position.to_sym
      break
    }
    if @stock.drink_delete(stock_position) == false
      "\n有効な入力では有りません"
    else
      "\n#{stock_position.to_s}の商品を削除しました"
    end
  end

  def vm_proceeds_decrease #売上金の回収
    if @salse_management.proceeds == 0
      "\n回収する売上金がありません"
    else
      text = "\n#{@salse_management.proceeds}円を回収しました"
      @salse_management.proceeds_decrease(@salse_management.proceeds)
      text
    end
  end
  #-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  def db_drink_data_register #商品の登録
    number = ""
    name = ""
    price = ""
    loop {
      puts "商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      number = gets.chomp

      if number == "end"
        return "\n入力を終了しました"
      elsif number !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      number = number.to_sym
      puts "登録する商品名を入力して下さい"
      name = gets.chomp

      if name !~ /^\S+$/
        puts "空白文字は使用できません"
        next
      end

      puts "登録する商品の値段を入力して下さい"
      price = gets.chomp

      if price !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      price = price.to_i
      break
    }
    if @product.drink_data_register(number, name, price) == false
      "\n既存商品と同じ商品番号は登録できません"
    else
      "\n商品番号:#{number.to_s} 商品名:#{name} 値段:#{price.to_s} を登録しました"
    end

  end

  def db_change_name #商品名の変更
    number = ""
    name = ""
    loop {
      puts "商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      number = gets.chomp

      if number == "end"
        return "\n入力を終了しました"
      elsif number !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      number = number.to_sym
      puts "変更後の商品名を入力して下さい"
      name = gets.chomp

      if name !~ /^\S+$/
        puts "空白文字は使用できません"
        next
      end
      break
    }
    if @product.change_name(number, name) == false
      "\n指定された商品番号が存在しません"
    else
      "\n商品番号:#{number.to_s}の商品名を#{name}に変更しました"
    end
  end

  def db_change_price #値段の変更
    number = ""
    price = ""
    loop {
      puts "値段の変更をする商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      number = gets.chomp

      if number == "end"
        return　"\n入力を終了しました"
      elsif number !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      number = number.to_sym
      puts "変更後の値段を入力して下さい"
      price = gets.chomp

      if price !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      price = price.to_i
      break
    }
    if @product.change_price(number, price) == false
      "\n指定された商品番号が存在しません"
    else
      "\n商品番号:#{number.to_s}の値段を#{price}円に変更しました"
    end
  end

  def db_drink_data_delete #商品の登録削除
    number = ""
    loop {
      puts "削除する商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      number = gets.chomp

      if number == "end"
        return "\n入力を終了しました"
      elsif number !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      number = number.to_sym
      break
    }
    if @stock.get_current_number.include?(number) == false
      if @product.drink_data_delete(number) == false
        "\n指定された商品番号が存在しません"
      else
        "\n商品番号:#{number}を削除しました"
      end
    else
      "\n自販機に割り当てている商品のため、削除できません"
    end
  end
end
