# coding: utf-8
#
# PadBoard - ゲーム管理クラス
#    ゲーム盤面をします 
#
require 'pad_util'

class PadBoard

  COLUMNS=6               # 横方向の数
  ROWS=5                  # 縦方向の数
  ITEMS=[1,2,3,4,5,6]     # 配置する数
  MIN_LEN=3               # ヒットとする数の最小値


  ## クラスメソッドの定義
  class << self

    # MIN_LEN以上同じ値が並ばないような配列を返す
    def no_sequence_board
      pad = nil
      while pad = PadBoard.new
        if !pad.is_sequence?
          break
        end
      end
      pad
    end

    # 2次=>1次の配列変換
    #   0-origin
    def pos(x,y)
      x + y*COLUMNS
    end

    # 線形の配列を配列の座標形式に変換する
    #   0-origin
    def coord(pos)
      [pos%COLUMNS,pos/COLUMNS]
    end

    # 縦もしくは横に隣接する値を返す
    def arounds(x,y)
      arounds = []
      if y > 0
        arounds.push [x,y-1]
      end
      if y < ROWS-1
        arounds.push [x,y+1]
      end
      if x > 0
        arounds.push [x-1,y]
      end
      if x < COLUMNS-1
        arounds.push [x+1,y]
      end
      arounds
    end

    # arounds にくわえ 斜めを追加する
    def arounds_with_angle(x,y)
      arounds = arounds(x,y)
      # 左上
      if (x > 0) && (y > 0)
        arounds.push [x-1,y-1]
      end
      # 右上
      if (x < COLUMNS-1) && (y > 0)
        arounds.push [x+1,y-1]
      end
      # 左下
      if (x > 0) && (y < ROWS-1)
        arounds.push [x-1,y+1]
      end
      # 右下
      if (x < COLUMNS-1) && (y < ROWS-1)
        arounds.push [x+1,y+1]
      end
      arounds
    end
  end

  def initialize(board=nil)
    if board.nil?
      # 配列にランダムな数値をセットする
      board = Array.new ROWS*COLUMNS
      board.size.times { |i| board[i] = rand(ITEMS.size)+1 } 
    end
    @board = board.dup
  end

  attr_accessor :board

  # テーブル形式で表示する
  def to_s
    str = ""
    each_row do |row|
      str += row.join(",") + "\n"
    end
    str
  end

  # 横方向に操作
  def each_row(&blk)
    ROWS.times do |r|
      yield @board[r*COLUMNS, COLUMNS], r
    end
  end

  # 縦方向に操作
  def each_column(&blk)
    COLUMNS.times do |c|
      columns = []
      ROWS.times do |r|
        columns[r] = @board[r*COLUMNS + c]
      end
      yield columns, c
    end
  end

  # MIN_LEN以上同じ数が並んでいるか調べる
  def sequence

    matched = []
    # 横方向でマッチするもの
    each_row do |row,r|
        val = row.sequence(MIN_LEN)
        val.each { |v| v.merge!(orient: :h, coord: [v[:pos], r]) }
        matched << val unless val.empty?
    end

    # 縦方向でマッチするもの
    each_column do |cols,c|
        val = cols.sequence(MIN_LEN)
        val.each { |v| v.merge!(orient: :v, coord: [c, v[:pos]]) }
        matched << val unless val.empty?
    end

    return matched.flatten
  end

  # MIN_LEN以上同じ数が並んでいるかを判定する
  def is_sequence?
    return !sequence.empty?
  end

  # 入れ替えの組み合わせを求める
  #   around_func は隣接する値のペアを取得するメソッド
  #   以下のいずれかを指定する
  #       :arounds = 縦方向・横方向で隣接するもの
  #       :arounds_with_angle = :arounds に斜め方向もくわえたもの
  def sequence_combination_by_swap(around_func=:arounds)

    # 隣接する値のペアの組み合わせを取得する
    #   (boardのインデックスに変換している)
    combinations = []
    COLUMNS.times do |x|
      ROWS.times do |y|
        combinations.push *PadBoard.send(around_func,x,y).map { |m| 
          [PadBoard.pos(x,y),PadBoard.pos(m[0],m[1])].sort }
      end
    end

    # １組の入れ替えを実施し、同じ値が並ぶ入れ替えの組み合わせを取得する
    seq_combinations = []
    combinations.uniq.each do |pos1,pos2|
      newboard = PadBoard.new(@board)

      # 入れ替え実施
      newboard.board[pos2] = @board[pos1]
      newboard.board[pos1] = @board[pos2]

      # 入れ替え後にMIN_LEN以上同じ値が並んでいるか
      if newboard.is_sequence?
        coord1 = PadBoard.coord(pos1) 
        coord2 = PadBoard.coord(pos2) 
        seq_combinations.push  [ {:coord=>coord1,:item=>self.board[pos1]},
                {:coord=>coord2,:item=>self.board[pos2]} ]
      end
    end
    seq_combinations
  end
end
