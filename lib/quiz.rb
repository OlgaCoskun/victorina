require "rexml/document" # Подключаем рубишный парсер

class Quiz
  attr_accessor :question, :quiz, :questions, :questions_arr, :question_nodes, :correct_answers

  def self.read_from_xml(file_name)
    doc = REXML::Document.new(File.read(file_name))
    question_nodes = doc.get_elements('questions/question') # Массив с вопросами по блокам(3 шт)

    questions = question_nodes.map {|node| Question.from_xml_node(node)} # Массив объектов класса Quiz

    new(questions)
  end

  def initialize(questions)
    @questions = questions
    @index = 0
    @correct_answers = 0
  end

  def ask_next_question
    @question = @questions[@index]
    @index += 1
  end

  def finished?
    @index >= @questions.size
  end

  def main
    until finished?
      ask_next_question
      puts question

      users_answer = nil
      begin
        t = question.time_for_question # Берем время из файла на проверку для гема

        # Гем timeout
        status = Timeout::timeout(t) {
          users_answer = STDIN.gets.to_i
        }
      rescue # Ловим ошибку выдаем сообщение об этом
        puts "Ваше время на вопрос истекло!"
        puts
        next # Продолжаем задавать следующий вопрос
      end

      if question.answer_is_correct?(users_answer)
        puts "Правильный ответ!"
        @correct_answers += 1
      else
        puts "Не правильный ответ!"
      end
    end
  end
end