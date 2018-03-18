class Question
  attr_accessor :time, :text, :variants, :time_for_question

  def self.from_xml_node(node)
    question = node
    time = question.attributes["seconds"] # Вытаскиваем строку со временем

    text = question.elements["text"].text # Вытаскиваем строку с вопросом для пользователя

    mixed_variant_nodes = question.get_elements('variants/variant').shuffle # Мешаем варианты ответов

    # Вытаскиваем все варианты ответов и кладем их в массив
    variants = mixed_variant_nodes.map {|val| val[0]}

    # Вытаскиваем правильный ответ с помощью метода index
    right_answer_index = mixed_variant_nodes.index {|val| val.attributes["right"]}

    new(time, text, variants, right_answer_index) # Передаем аргументы для метода new
  end

  def initialize(time, text, variants, right_answer_index)
    @time = time
    @text = text
    @variants = variants
    @right_answer_index = right_answer_index
    @time_for_question = time.to_i # Берем время из файла
  end

  def to_s # Выводим все сразу
    <<~HEREDOC
      На этот вопрос Вам дается #{time} сек
      #{text}
      #{variants.map.with_index {|val, index| "#{index + 1} - #{val}"}.join("\n")}
    HEREDOC
  end

  def answer_is_correct?(users_answer)
    @right_answer_index == users_answer - 1
  end
end