require_relative "lib/question"
require_relative "lib/quiz"
require "timeout"

current_path = File.dirname(__FILE__)
file_name = current_path + "/data/questions.xml"

file = File.new(file_name)
quiz = Quiz.read_from_xml(file_name)

puts quiz.main
puts "Правильных ответов - #{quiz.correct_answers}"
