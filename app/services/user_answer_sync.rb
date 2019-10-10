class UserAnswerSync
  FIELD_MAPPINGS = {
    :name => 'kSHzJrMOjcMD',
    :email => 'qFfhkmeEyC9G',
    :object => 'dzfVsFu5xbTU',
    #:rating => 'YcqKcFDtrrjV'
  }

  TYPE_MAPPINGS = {
    :name => "text",
    :email => "text",
    :object => "text",
    #:rating => { "choice" => "label" }
  }

  def initialize(questions, answers)
    @questions = questions
    @answers = answers
  end

  def run
    User.create!(
      name: find_answer("name"),
      email: find_answer("email"),
      object: find_answer("object")
    )
  end

  def find_answer(param)
    puts @answers.class
    @answers.to_unsafe_h.find { |h| h[:field][:id] == FIELD_MAPPINGS[:param] }[:"#{TYPE_MAPPINGS[:param]}"]
  end
end
