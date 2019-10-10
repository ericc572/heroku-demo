class HooksController < ApplicationController
  def survey_created
    # If the body contains the form_response parameter...
    data = JSON.parse(response.body)
    if data[:response_type].present?
      # Create a new Survey object based on the received parameters...
      response = data[:form_response]
      questions = data[:definition]
      answers = data[:answers]

     data[:answers].map do |a|
      answer_type = a['type']
      Survey.create!(
        question_id: a['field']['id'],
        answer_type: answer_type,
        answer: a[answer_type]
      )
     end
    end

    # The webhook doesn't require a response but let's make sure
    # we don't send anything
    render :nothing => true
  end
end
