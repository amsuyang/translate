#!/usr/bin/env ruby

# delete white space characters (spaces, tabs, etc.) from blank lines

require 'find'

require_relative 'config'

Find.find($data_dir) do |name|
  next if ['.', '..'].include?(name)
  next if File.directory? name

  new_lines = []

  File.open(name) do |file|
    file.each_line do |line|
      if /^\s+$/ =~ line
        new_lines.push "\n"
      else
        line.chomp!
        new_lines.push line
      end
    end
  end

  File.open(name, 'w') do |file|
    new_lines.each do |line|
      file.puts line
    end
  end
end
