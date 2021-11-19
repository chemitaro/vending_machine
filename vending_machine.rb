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
      i = gets.chomp
      if i =~ /^\d+$/ && i.to_i > 0
        slot_number = i.to_i
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
      information_display("sales") #salesモードの商品表示
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
      information_display("admin") #adminモードのの商品表示
      puts "------------------------------------------------------------------------"
      puts "自動販売機内金額：#{@salse_management.proceeds}円"
      puts "------------------------------------------------------------------------"
      puts "\n\n----------------------------商品情報------------------------------------"
      product_information_display #データベースの商品情報
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
    information = "\n自動販売機管理モード中"
    loop {
      puts "\n\n\n\n----------------------------商品情報------------------------------------"
      product_information_display #商品情報
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
  def information_display(user) #自販機内の商品情報出力
    d = @product.drink_data
    s = @insert.slot_money
    drink_list = @stock.drink_list_creation(d, s)

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

  def product_information_display #登録されている商品情報の表示
    drink_data = @product.drink_data
    drink_data.each{ |number, name_price|
      puts "\n商品番号：#{number}　商品名：#{name_price[:name]}　値段：#{name_price[:price]}"
    }
  end

  def deposit(user_input) #お金の投入
    user_input = user_input.to_i
    if @insert.money_judgement(user_input)
      @insert.money_increase(user_input)
      "\n#{user_input}円を投入しました"
    else
      "\n有効な貨幣では有りません、以下の貨幣が使用できます\n硬貨:10円, 50円, 100円, 500円\n紙幣:1000円\n#{user_input}円を返却しました"
    end
  end

  def return_money #返金処理
    text = "\n#{@insert.slot_money}円を返却しました"
    @insert.money_decrease(@insert.slot_money)
    return text
  end

  def push_button(user_input) #購入処理
    user_input = user_input.to_sym
    puts "開始"
    case @stock.drink_buyable_judgement(user_input, @product.drink_data, @insert.slot_money)
    when 1
      @stock.drink_decrease(user_input, 1)
      price = @stock.drink_price(user_input, @product.drink_data)
      @insert.money_decrease(price)
      @salse_management.proceeds_increase(price)
      @my_orders << "#{@stock.drink_name(user_input, @product.drink_data)}"
      "\nガコン！　#{@stock.drink_name(user_input, @product.drink_data)}を購入しました" + return_money
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
    user_input_1 = ""
    user_input_2 = ""
    user_input_3 = ""
    loop {
      puts "割り当てる自販機ボタンのアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      user_input_1 = gets.chomp

      if user_input_1 == "end"
        return "\n入力を終了しました"
      elsif user_input_1 !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      user_input_1 = user_input_1.to_sym

      puts "商品番号を入力して下さい 例：d001"
      user_input_2 = gets.chomp
      if user_input_2 !~ /^d\d{3}$/ || @product.number_present?(user_input_2.to_sym) == false
        puts "有効な入力情報では有りません"
        next
      end

      user_input_2 = user_input_2.to_sym

      puts "補充する本数を半角数字で入力して下さい"
      user_input_3 = gets.chomp
      if user_input_3 !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      user_input_3 = user_input_3.to_i
      break
    }

    if @stock.drink_addition(user_input_1, user_input_2, user_input_3) == false
      "\n指定された商品スロットは存在しません"
    else
      "\n#{user_input_1.to_s}へ#{user_input_2.to_s}を#{user_input_3}本割り当てました"
    end
  end

  def vm_drink_increase #自販機の商品補充
    user_input_1 = ""
    user_input_2 = ""
    loop {
      puts "補充する商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      user_input_1 = gets.chomp

      if user_input_1 == "end"
        return "\n入力を終了しました"
      elsif user_input_1 !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      user_input_1 = user_input_1.to_sym
      puts "補充する本数を半角数字で入力して下さい"

      user_input_2 = gets.chomp

      if user_input_2 !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end

      user_input_2 = user_input_2.to_i
      break
    }
    if @stock.drink_increase(user_input_1, user_input_2) == false
      "\n有効な入力では有りません"
    else
      "\n#{user_input_1.to_s}の商品を#{user_input_2}本追加しました"
    end
  end

  def vm_drink_decrease#自販機の商品を削減
    user_input_1 = ""
    user_input_2 = ""
    loop {
      puts "本数を減らす商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      user_input_1 = gets.chomp

      if user_input_1 == "end"
        return "\n入力を終了しました"
      elsif user_input_1 !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      user_input_1 = user_input_1.to_sym
      puts "減らす本数を半角数字で入力して下さい"
      user_input_2 = gets.chomp

      if user_input_2 !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      user_input_2 = user_input_2.to_i
      break
    }
    if @stock.drink_decrease(user_input_1, user_input_2) == false
      "\n有効な入力では有りません"
    else
      "\n#{user_input_1.to_s}の商品を#{user_input_2}本減らしました"
    end
  end

  def vm_drink_deleate #自販機の商品の削除
    user_input = ""
    loop {
      puts "削除する商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      user_input = gets.chomp

      if user_input == "end"
        return "\n入力を終了しました"
      elsif user_input !~ /^[A-Z]$/
        puts "有効なアルファベットでは有りません"
        next
      end
      user_input = user_input.to_sym
      break
    }
    p user_input
    if @stock.drink_delete(user_input) == false
      "\n有効な入力では有りません"
    else
      "\n#{user_input.to_s}の商品を削除しました"
    end
  end

  def vm_proceeds_decrease #売上金の回収
    if @salse_management.proceeds == 0
      "\n回収する売上金がありません"
    else
      text = "\n#{@salse_management.proceeds}円を回収しました"
      @salse_management.proceeds_decrease(@salse_management.proceeds)
      return text
    end
  end
  #-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  def db_drink_data_register #商品の登録
    user_input_1 = ""
    user_input_2 = ""
    user_input_3 = ""
    loop {
      puts "商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      user_input_1 = gets.chomp

      if user_input_1 == "end"
        return "\n入力を終了しました"
      elsif user_input_1 !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      user_input_1 = user_input_1.to_sym
      puts "登録する商品名を入力して下さい"
      user_input_2 = gets.chomp

      if user_input_2 !~ /^\S+$/
        puts "空白文字は使用できません"
        next
      end

      puts "登録する商品の値段を入力して下さい"
      user_input_3 = gets.chomp

      if user_input_3 !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      user_input_3 = user_input_3.to_i
      break
    }
    if @product.drink_data_register(user_input_1, user_input_2, user_input_3) == false
      "\n既存商品と同じ商品番号は登録できません"
    else
      "\n商品番号:#{user_input_1.to_s} 商品名:#{user_input_2} 値段:#{user_input_3.to_s} を登録しました"
    end

  end

  def db_change_name #商品名の変更
    user_input_1 = ""
    user_input_2 = ""
    loop {
      puts "商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      user_input_1 = gets.chomp

      if user_input_1 == "end"
        return "\n入力を終了しました"
      elsif user_input_1 !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      user_input_1 = user_input_1.to_sym
      puts "変更後の商品名を入力して下さい"
      user_input_2 = gets.chomp

      if user_input_2 !~ /^\S+$/
        puts "空白文字は使用できません"
        next
      end
      break
    }
    if @product.change_name(user_input_1, user_input_2) == false
      "\n指定された商品番号が存在しません"
    else
      "\n商品番号:#{user_input_1.to_s}の商品名を#{user_input_2}に変更しました"
    end
  end

  def db_change_price #値段の変更
    user_input_1 = ""
    user_input_2 = ""
    loop {
      puts "値段の変更をする商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      user_input_1 = gets.chomp

      if user_input_1 == "end"
        return　"\n入力を終了しました"
      elsif user_input_1 !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      user_input_1 = user_input_1.to_sym
      puts "変更後の値段を入力して下さい"
      user_input_2 = gets.chomp

      if user_input_2 !~ /^\d+$/
        puts "有効な数字では有りません"
        next
      end
      user_input_2 = user_input_2.to_i
      break
    }
    if @product.change_price(user_input_1, user_input_2) == false
      "\n指定された商品番号が存在しません"
    else
      "\n商品番号:#{user_input_1.to_s}の値段を#{user_input_2}円に変更しました"
    end
  end

  def db_drink_data_delete #商品の登録削除
    user_input = ""
    loop {
      puts "削除する商品番号を入力して下さい 例：d001 \n入力を終了する場合は end を入力して下さい"
      user_input = gets.chomp

      if user_input == "end"
        return "\n入力を終了しました"
      elsif user_input !~ /^d\d{3}$/
        puts "有効な入力情報では有りません"
        next
      end
      user_input = user_input.to_sym
      break
    }
    if @stock.get_current_number.include?(user_input) == false
      if @product.drink_data_delete(user_input) == false
        "\n指定された商品番号が存在しません"
      else
        "\n商品番号:#{user_input}を削除しました"
      end
    else
      "\n自販機に割り当てている商品のため、削除できません"
    end
  end
end
