#確認事項
#drink_list_creationの戻り値の詳細の確認、information_displayに必要
#各メソッドへの引数のデータ型の確認
#各処理完了後のメッセージに使用する変数値の取得方法及びメッセージの出力
#puish_button要改善、information_display作成時に変数へ商品情報を格納しそこから読み取る？



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
    @stock = Stock.new
    @salse_management = SalseManagement.new
    mode_selection
  end

  def mode_selection
    #各モードへの選択モード
    loop {
      "\nモード選択"
      "任意の数字を入力してエンターキーを押して下さい"
      "sales_mode：1"
      "admin_mode：2"
      "product_db_mode：3"
      "プログラム終了：4"

      user_input = gets.chomp
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
        "有効な入力では有りません"
      end
    }
  end

  def sales_mode
    #商品購入モード
    loop {
      "\n\n------------------------------------------------------------------------"
      "---------------------------自動販売機-----------------------------------"
      "------------------------------------------------------------------------"
      information_display
      #商品表示
      "\n------------------------------------------------------------------------"
      "投入残金額#{@insert.slot_money}円"
      #   if @my_orders.length == 0
      #     "購入品：なし"
      #   else
      #     "購入品：#{@my_orders.join(',')}"
      #   end
      "------------------------------------------------------------------------"

      "\nいらっしゃいませ！"
      "使用方法"
      "以下の任意の文字及び数字を入力し、エンターキーを押して下さい"

      "お金の投入：任意の金額を半角数字　例.100円を投入するときは 100"
      "商品購入:商品ボタンのアルファベット　例：A"
      "投入金の返金：返金"
      "買い物を終了：end"

      user_input = gets.chomp
      case user_input
      when /\d+/
        #半角数字が1文字以上だったら
        deposit(user_input)
      when "返金"
        return_money
        #返金処理
      when /[A-Z]/
        #アルファベットだったら
        push_button(user_input)
        #購入処理
      when "end"
        break
      else
        "有効な入力では有りません"
      end
    }
  end

  def admin_mode
    #管理者モード
    loop {
      "\n\n---------------------------自動販売機-----------------------------------"
      information_display
      #自販機情報
      "------------------------------------------------------------------------"
      "自動販売機内金額：#{@salse_management.proceeds}円"

      "\n\n----------------------------商品情報------------------------------------"
      product_information_display
      #商品情報
      "------------------------------------------------------------------------"

      "\自動販売機管理モード"
      "任意の数字を入力してエンターキーを押して下さい"

      "自販機への商品割当：1"
      "自販機商品の個数補充：2"
      "自販機商品の個数を減らす：3"
      "自販機商品の削除：4"
      "売上金の回収：5"
      "管理モードの終了：6"

      user_input = gets.chomp
      case user_input
      when 1
        vm_drink_allocation
      when 2
        vm_drink_increase
      when 3
        vm_drink_decrease
      when 4
        vm_drink_deleate
      when 5
        vm_proceeds_decrease
      when 6
        break
      else
        "有効な入力では有りません"
      end
    }
  end


  def product_db_mode
    loop {
      "\n\n----------------------------商品情報------------------------------------"
      product_information_display
      #商品情報
      "------------------------------------------------------------------------"

      "\商品情報管理モード"
      "任意の数字を入力してエンターキーを押して下さい"

      "商品の登録：1"
      "商品名の変更：2"
      "値段の変更：3"
      "商品の登録削除：4"
      "管理モードの終了：5"

      user_input = gets.chomp
      case user_input
      when 1
        db_drink_data_register
      when 2
        db_change_name
      when 3
        db_change_price
      when 4
        db_drink_data_delete
      when 5
        break
      else
        "有効な入力では有りません"
      end
    }
  end
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  def information_display
    #putsで情報出力
    i = @product.drink_data
    j = @insert.slot_money
    @stock.drink_list_creation(i, j)
    #どのようなデータ構造か確認
    #   @products.each{|product_name, price_stock|
    #     if price_stock[:stock] == 0
    #       #もし在庫がなかったら
    #       puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]} 在庫切れ"
    #     elsif @slot_money < price_stock[:price]
    #       #もし投入金額が足りなかったら
    #       puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]} お金が足りません"
    #     elsif @slot_money >= price_stock[:price] && price_stock[:stock] > 0
    #       #もし投入金額が足りており、在庫もあったら
    #       puts "\n#{product_name}　値段:#{price_stock[:price]}円 在庫:#{price_stock[:stock]} 購入可能"
    #     end
    #   }
  end

  def product_information_display
    #登録されている商品情報の表示
    drink_data = @product.drink_data
    #商品情報の取得
    drink_data.each{ |number, name_price|
      #商品情報表示
      "\n商品番号：#{number}　商品名：#{name_price[:name]}　値段：#{name_price[:price]}"
    }
  end

  def deposit(user_input)
    #投入されたお金が使用できるか判断する
    user_input = user_input.to_i
    if @insert.money_judgement(user_input)
      #使えればInsertクラスのメソッドに引数を渡す
      @insert.money_addition(user_input)
    else
      #使えなかったら使えないメッセージを出力
      "有効な金額では有りません"
    end
  end

  def return_money
    #返金処理
    @insert.money_decrease(@insert.money_amount)
  end


  def push_button(user_input)
    #購入処理
    #要改善
    case @stock.drink_buyable_judgement(user_input, @insert.slot_money)
    when 1
      #購入可能なら
      @stock.drink_decrease(user_input, 1)
      #個数を減らす
      price = product.@drink_data[@stock.drink_stock[user_input.to_sym][0].to_sym][2]
      #金額取得、要改善
      @salse_management.proceeds_decrease(price)
      "\nガコン！　#{product.@drink_data[@stock.drink_stock[user_input.to_sym][0].to_sym][1]}を購入"
    when 2
      "\n投入代金が不足しています"
    when 3
      "\n申し訳有りません、商品が品切れ中です"
    when 4
      "\n商品が存在しません、有効なアルファベットを入力して下さい"
    end
  end
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  def vm_drink_allocation
    #自販機への商品割当
    drink_data = @product.drink_data
    #商品情報の取得
    loop {
      "割り当てる自販機ボタンのアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /[A-Z]/
        #もしアルファベットではなかったら
        "有効なアルファベットでは有りません"
        next
      end
      "商品番号を半角数字で入力して下さい"
      @user_input_2 = gets.chomp
      if @user_input_2 !~ /\d{3}/
        #もし3桁の数字ではなかったら
        "有効な数字では有りません"
        next
      end
      @user_input_2 = @user_input_2.to_i
      break
    }
    @stock.drink_addition(@user_input_1, @user_input_2)
  end

  def vm_drink_increase
    #自販機の商品補充
    loop {
      "補充する商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /[A-Z]/
        #もしアルファベットではなかったら
        "有効なアルファベットでは有りません"
        next
      end
      "補充する個数を半角数字で入力して下さい"
      @user_input_2 = gets.chomp
      if @user_input_2 !~ /\d+/
        #もし数字ではなかったら
        "有効な数字では有りません"
        next
      end
      @user_input_2 = @user_input_2.to_i
      break
    }
    @stock.drink_addition(@user_input_1, @user_input_2)
  end

  def vm_drink_decrease
    #自販機の商品を減らす
    loop {
      "個数を減らす商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /[A-Z]/
        #もしアルファベットではなかったら
        "有効なアルファベットでは有りません"
        next
      end
      "減らす個数を半角数字で入力して下さい"
      @user_input_2 = gets.chomp
      if @user_input_2 !~ /\d+/
        #もし数字ではなかったら
        "有効な数字では有りません"
        next
      end
      @user_input_2 = @user_input_2.to_i
      break
    }
    @stock.drink_decrease(@user_input_1, @user_input_2)
  end

  def drink_deleate
    #自販機の商品の削除
    loop {
      "削除する商品の自販機ボタンアルファベットを半角大文字で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /[A-Z]/
        #もしアルファベットではなかったら
        "有効なアルファベットでは有りません"
        next
      end
      break
    }
    @stock.drink_decrease(@user_input_1, @user_input_2)
  end

  def vm_proceeds_decrease
    #売上金の回収
    "#{@salse_management.proceeds}円を回収しました"
    @salse_management.proceeds_decrease
  end
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  def db_drink_data_register
    #商品の登録
    loop {
      "登録する商品の番号を半角数字3桁で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /\d{3}/
        "有効な数字では有りません"
        next
      end
      ＠user_input_1 = @user_input_2.to_i

      "登録する商品を入力して下さい"
      @user_input_2 = gets.chomp

      "登録する商品の値段を入力して下さい"
      @user_input_3 = gets.chomp
      if @user_input_3 !~ /\d+/
        "有効な数字では有りません"
        next
      end
      break
    }
    @product.drink_data_register(@user_input_1, @user_input_2, @user_input_3)

  end

  def db_change_name
    #商品名の変更
    loop {
      "名称の変更をする商品の番号を半角数字3桁で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /\d{3}/
        "有効な数字では有りません"
        next
      end
      ＠user_input_1 = @user_input_2.to_i

      "変更後の商品名を入力して下さい"
      @user_input_2 = gets.chomp
      break
    }
    @product.change_name(@user_input_1, @user_input_2)
  end

  def db_change_price
    #値段の変更
    loop {
      "値段の変更をする商品の番号を半角数字3桁で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input_1 = gets.chomp
      if @user_input_1 == "end"
        "入力を終了します"
        break
      elsif @user_input_1 !~ /\d{3}/
        "有効な数字では有りません"
        next
      end
      ＠user_input_1 = @user_input_2.to_i

      "変更後の値段を入力して下さい"
      @user_input_2 = gets.chomp
      if @user_input_2 !~ /\d+/
        "有効な数字では有りません"
        next
      end
      break
    }
    @product.change_price(@user_input_1, @user_input_2)
  end

  def db_drink_data_delete
    #商品の登録削除
    loop {
      "削除する商品の番号を半角数字3桁で入力して下さい、入力を終了する場合は end を入力して下さい"
      @user_input = gets.chomp
      if @user_input == "end"
        "入力を終了します"
        break
      elsif @user_input !~ /\d{3}/
        "有効な数字では有りません"
        next
      end
      break
    }
    @product.drink_data_delete(@user_input)
  end

end
