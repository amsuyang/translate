#!/usr/bin/env ruby

require 'find'

require_relative 'data_dir'

# merge consecutive blank lines
def merge_blank_lines(lines)
  new_lines = []
  previous_line_is_blank = false
  current_line_is_blank = false
  regex_blank_line = /^$/

  lines.each do |line|
    current_line_is_blank = if regex_blank_line =~ line
                              true
                            else
                              false
                            end

    next if previous_line_is_blank && current_line_is_blank

    previous_line_is_blank = current_line_is_blank

    new_lines.push(line)
  end

  new_lines
end

Find.find($data_dir) do |name|
  next if ['.', '..'].include?(name)
  next if File.directory? name

  file = File.open(name, 'r')

  lines = merge_blank_lines(file.readlines)

  file.close

  file = File.open(name, 'w')

  lines.each do |line|
    line.chomp!
    file.puts line
  end

  file.close
end
