# coding: utf-8
#
module PadUtil
  # �z�񂩂� min �ȏ㓯���l�������Ă��������̏���Ԃ�
  #   empty : min�ȏ㓯���l�������Ă��������Ȃ�
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

# Array�N���X���g��
class Array
  include PadUtil
end
