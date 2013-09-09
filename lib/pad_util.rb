# coding: utf-8
#
module PadUtil
  # 配列から min 以上同じ値が続いていた部分の情報を返す
  #   empty : min以上同じ値が続いていた部分なし
  def sequence(min=3)
    pre = nil
    len = 0
    pos = 0
    matches = []

    self.each_with_index do |cur, i|
      raise RuntimeError, "Invalid value self[#{i}]" if cur.nil?

      if pre.nil? || pre == cur
        len += 1
      else
        if len >= min
          matches << { pos:pos, len:len, item:pre }
        end
        len = 1
        pos = i
      end
      pre = cur
    end

    if len >= min
      matches << { pos:pos, len:len, item:pre }
    end
    matches
  end
end

# Arrayクラスを拡張
class Array
  include PadUtil
end
