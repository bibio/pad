#! /usr/bin/env ruby
# coding: utf-8

#--
# 簡易パズドラ実行プログラム
#--

$: << File.expand_path(__FILE__) + "/lib"
require 'pad_runner'

args = ARGV.clone

begin
  PadRunner.new args
rescue SignalException => e
  exit 1
end
