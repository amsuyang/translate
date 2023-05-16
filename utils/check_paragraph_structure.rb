#!/usr/bin/env ruby

require 'find'

require_relative 'config'

Find.find($data_dir) do |name|
  next if ['.', '..'].include?(name)
  next if File.directory? name

  file = File.open(name, 'r')

  lines = file.readlines

  file.close

  blank_lines_count = 0
  lines.each do |line|
    if /^$/ =~ line
      blank_lines_count += 1
    end
  end

  puts "#{name}, '==>', #{blank_lines_count}" if blank_lines_count != 6
end
