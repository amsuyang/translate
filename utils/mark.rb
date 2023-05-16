#!/usr/bin/env ruby

require 'find'
require_relative 'config'

def read_file(name)
  File.readlines(name)
end

def write_file(name, lines)
  File.open(name, 'w') do |file|
    file.puts lines
  end
end

# use <^^> to mark Lesson
def mark_lesson(lines)
  return unless /\s*(Lesson)\s+(\d+)/ =~ lines[0]

  lines[0] = "<^#{Regexp.last_match(1)} #{Regexp.last_match(2)}^>"
end

# use <%%> and <&&> to mark Title
def mark_title(lines)
  lines[1].strip!
  lines[2].strip!

  /((\w+\s*)+)(.)?/ =~ lines[1]
  lines[1] = "<%#{Regexp.last_match(1)}#{Regexp.last_match(3)}%>"
  lines[1].sub!(/%{2,}/, '%')

  lines[2] = "<&#{lines[2]}&>"
  lines[2].sub!(/(<&){2,}/, '<&')
  lines[2].sub!(/(&>){2,}/, '&>')
end

# use <@@> to mark Original text
def mark_original(lines)
  start_index = nil
  end_index = nil

  blank_line_counter = 0
  lines.each_with_index do |line, i|
    if /^$/ =~ line
      blank_line_counter += 1
    end

    if blank_line_counter == $blank_line_num_before_original
      start_index = i + 1
      break
    end
  end

  blank_line_counter = 0
  lines.each_with_index do |line, i|
    if /^$/ =~ line
      blank_line_counter += 1
    end

    if blank_line_counter == $blank_line_num_after_original
      end_index = i - 1
      break
    end
  end

  lines[start_index].strip!
  lines[end_index].strip!

  lines[start_index] = "<@#{lines[start_index]}"
  lines[end_index] = "#{lines[end_index]}@>"

  lines[start_index].sub!(/(<@){2,}/, '<@')
  lines[end_index].sub!(/(@>){2,}/, '@>')
end

# use <$$> to mark Translation
def mark_translation(lines)
  start_index = nil
  end_index = lines.size - 1

  blank_line_counter = 0
  lines.each_with_index do |line, i|
    if /^$/ =~ line
      blank_line_counter += 1
    end

    next unless blank_line_counter == $blank_line_num_before_translation

    start_index = i + 1
    break
  end

  lines[start_index].strip!
  lines[end_index].strip!

  lines[start_index] = "<$#{lines[start_index]}"
  lines[end_index] = "#{lines[end_index]}$>"

  lines[start_index].sub!(/(<\$){2,}/, '<$')
  lines[end_index].sub!(/(\$>){2,}/, '$>')
end

Find.find($data_dir) do |name|
  next if %w[. ..].include? name
  next if File.directory? name

  lines = read_file(name)

  mark_lesson(lines)
  mark_title(lines)
  mark_original(lines)
  mark_translation(lines)

  write_file(name, lines)
end
