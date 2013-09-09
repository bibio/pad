# coding: utf-8
#
# PadRunner 
#　　引数の操作やコマンドラインインタフェース部分を定義しています
#
require 'pad_board'

class PadRunner

  def initialize(*args)
    welcome 

    loop do
      mode = prompt 
      if mode.nil?
        redo
      end
      if mode == :quit
        break
      end
      run mode
    end

    bye
  end

  private

  def welcome
    puts "パズドラシミュレーション"
    puts ""
  end

  def bye
    puts "bye."
  end

  def run(menu)
    self.send(menu)
  end

  def show_seq_pattern

    caption_orient = { :h=>"横", :v=>"縦" }
    board = PadBoard.new
    seq = board.sequence

    puts ""
    puts "[ボード]"
    puts board.to_s
    puts ""
    puts "[マッチ]"
    if seq.empty?
      puts "なし"
    else
      seq.each_with_index do |s,i|
        puts "[#{i+1}] 方向: #{caption_orient[s[:orient]]} 座標: (#{s[:coord]*','}) ヒット数: #{s[:len]} ラベル: #{s[:item]}"
      end
    end
    puts ""

  end

  def no_seq_pattern
    board = PadBoard.no_sequence_board
    puts ""
    puts "[ボード]"
    puts board.to_s
    puts ""
  end

  def swap_around 
    board = PadBoard.no_sequence_board
    seq_combinations = board.sequence_combination_by_swap
    puts ""
    puts "[ボード]"
    puts board.to_s
    puts ""
    puts "[入れ替えのペア]"
    if seq_combinations.empty?
      puts "なし"
    else
      seq_combinations.each_with_index do |s,i|
        puts "[#{i+1}]  (#{s[0][:coord].join(",")}) [#{s[0][:item]}] <=> (#{s[1][:coord].join(",")}) [#{s[1][:item]}]"
      end
    end
    puts ""
  end

  def swap_around_with_angle
    board = PadBoard.no_sequence_board
    seq_combinations = board.sequence_combination_by_swap :arounds_with_angle
    puts ""
    puts "[ボード]"
    puts board.to_s
    puts ""
    puts "[入れ替えのペア]"
    if seq_combinations.empty?
      puts "なし"
    else
      seq_combinations.each_with_index do |s,i|
        puts "[#{i+1}]  (#{s[0][:coord].join(",")}) [#{s[0][:item]}] <=> (#{s[1][:coord].join(",")}) [#{s[1][:item]}]"
      end
    end
    puts ""
  end

  # 入力画面 
  def prompt

    mode_map = { 
      "1"=>:show_seq_pattern, 
      "2"=>:no_seq_pattern, 
      "3"=>:swap_around, 
      "4"=>:swap_around_with_angle, 
      "9"=>:quit 
    }

    menu =<<EOF
メニュー）
1: ３つ以上同じ値が並ぶ組み合わせを表示
2: 縦にも横にも３つ以上同じ値が配置されれない
3: 縦または横を入れ替えた場合に３つ以上同じ値が並ぶ組み合わせを表示
4: 隣接する斜めの入れ替えも含めて組み合わせを表示
9: 終了
EOF
    puts menu 
    print "メニューを入力してください(12349)> "

    uinput = STDIN.gets().strip.to_s

    case uinput
    when "1", "2", "3", "4", "9"
      return mode_map[uinput]
    else
      puts "！！エラー：不正な入力です(#{uinput})"
      puts
    end
    return nil
  end
end
