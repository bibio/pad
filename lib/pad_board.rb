# coding: utf-8
#
# PadBoard - �Q�[���Ǘ��N���X
#    �Q�[���Ֆʂ����܂� 
#
require 'pad_util'

class PadBoard

  COLUMNS=6               # �������̐�
  ROWS=5                  # �c�����̐�
  ITEMS=[1,2,3,4,5,6]     # �z�u���鐔
  MIN_LEN=3               # �q�b�g�Ƃ��鐔�̍ŏ��l


  ## �N���X���\�b�h�̒�`
  class << self

    # MIN_LEN�ȏ㓯���l�����΂Ȃ��悤�Ȕz���Ԃ�
    def no_sequence_board
      pad = nil
      while pad = PadBoard.new
        if !pad.is_sequence?
          break
        end
      end
      pad
    end

    # 2��=>1���̔z��ϊ�
    #   0-origin
    def pos(x,y)
      x + y*COLUMNS
    end

    # ���`�̔z���z��̍��W�`���ɕϊ�����
    #   0-origin
    def coord(pos)
      [pos%COLUMNS,pos/COLUMNS]
    end

    # �c�������͉��ɗאڂ���l��Ԃ�
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

    # arounds �ɂ��킦 �΂߂�ǉ�����
    def arounds_with_angle(x,y)
      arounds = arounds(x,y)
      # ����
      if (x > 0) && (y > 0)
        arounds.push [x-1,y-1]
      end
      # �E��
      if (x < COLUMNS-1) && (y > 0)
        arounds.push [x+1,y-1]
      end
      # ����
      if (x > 0) && (y < ROWS-1)
        arounds.push [x-1,y+1]
      end
      # �E��
      if (x < COLUMNS-1) && (y < ROWS-1)
        arounds.push [x+1,y+1]
      end
      arounds
    end
  end

  def initialize(board=nil)
    if board.nil?
      # �z��Ƀ����_���Ȑ��l���Z�b�g����
      board = Array.new ROWS*COLUMNS
      board.size.times { |i| board[i] = rand(ITEMS.size)+1 } 
    end
    @board = board.dup
  end

  attr_accessor :board

  # �e�[�u���`���ŕ\������
  def to_s
    str = ""
    each_row do |row|
      str += row.join(",") + "\n"
    end
    str
  end

  # �������ɑ���
  def each_row(&blk)
    ROWS.times do |r|
      yield @board[r*COLUMNS, COLUMNS], r
    end
  end

  # �c�����ɑ���
  def each_column(&blk)
    COLUMNS.times do |c|
      columns = []
      ROWS.times do |r|
        columns[r] = @board[r*COLUMNS + c]
      end
      yield columns, c
    end
  end

  # MIN_LEN�ȏ㓯����������ł��邩���ׂ�
  def sequence

    matched = []
    # �������Ń}�b�`�������
    each_row do |row,r|
        val = row.sequence(MIN_LEN)
        val.each { |v| v.merge!(orient: :h, coord: [v[:pos], r]) }
        matched << val unless val.empty?
    end

    # �c�����Ń}�b�`�������
    each_column do |cols,c|
        val = cols.sequence(MIN_LEN)
        val.each { |v| v.merge!(orient: :v, coord: [c, v[:pos]]) }
        matched << val unless val.empty?
    end

    return matched.flatten
  end

  # MIN_LEN�ȏ㓯����������ł��邩�𔻒肷��
  def is_sequence?
    return !sequence.empty?
  end

  # ����ւ��̑g�ݍ��킹�����߂�
  #   around_func �͗אڂ���l�̃y�A���擾���郁�\�b�h
  #   �ȉ��̂����ꂩ���w�肷��
  #       :arounds = �c�����E�������ŗאڂ������
  #       :arounds_with_angle = :arounds �Ɏ΂ߕ��������킦������
  def sequence_combination_by_swap(around_func=:arounds)

    # �אڂ���l�̃y�A�̑g�ݍ��킹���擾����
    #   (board�̃C���f�b�N�X�ɕϊ����Ă���)
    combinations = []
    COLUMNS.times do |x|
      ROWS.times do |y|
        combinations.push *PadBoard.send(around_func,x,y).map { |m| 
          [PadBoard.pos(x,y),PadBoard.pos(m[0],m[1])].sort }
      end
    end

    # �P�g�̓���ւ������{���A�����l�����ԓ���ւ��̑g�ݍ��킹���擾����
    seq_combinations = []
    combinations.uniq.each do |pos1,pos2|
      newboard = PadBoard.new(@board)

      # ����ւ����{
      newboard.board[pos2] = @board[pos1]
      newboard.board[pos1] = @board[pos2]

      # ����ւ����MIN_LEN�ȏ㓯���l������ł��邩
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
