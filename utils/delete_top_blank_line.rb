#!/usr/bin/env ruby

require 'find'

require_relative 'config'

Find.find($data_dir) do |name|
  next if ['.', '..'].include?(name)
  next if File.directory? name

  file = File.open(name, 'r')

  lines = file.readlines

  file.close

  if /^$/ =~ lines[0]
    lines.shift
  end

  file = File.open(name, 'w')

  lines.each do |line|
    line.chomp!
    file.puts line
  end

  file.close
end
