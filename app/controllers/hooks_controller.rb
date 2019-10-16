class HooksController < ApplicationController
  FIELD_MAPPINGS = {
    :name => 'kSHzJrMOjcMD',
    :email => 'qFfhkmeEyC9G',
    :comment => 'uGwJkwgN6GEK'
  }

  TYPE_MAPPINGS = {
    :name => "text",
    :email => "text",
    :comment => "text"
    #:rating => { "choice" => "label" }
  }

  def survey_created
    # If the body contains the form_response parameter...
    data = params[:form_response]
    if data.present?
      # Create a new Survey object based on the received parameters...
      questions = data[:definition]
      answers = data[:answers]
      time = data[:submitted_at]

      comment = answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:comment] }[TYPE_MAPPINGS[:comment]]

      positive_percentage = EinsteinSentimentAnalyzerJob.perform_later(comment)

      Contact.create!(
        lastname: answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:name] }[TYPE_MAPPINGS[:name]],
        email: answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:email] }[TYPE_MAPPINGS[:email]],
        customersatisfaction__c: positive_percentage
      )
    end
    render status: 200, json: @s.to_json
  end

  def sms_received
    puts "SMS was received. Saving data now: "
    if params.present?
      SmsResponse.create!(
        phone_number: params[:participant_phone_number],
        question: params[:question_text],
        response_timestamp: params[:result_timestamp],
        response_choice: params[:result_answer],
        response_answer: params[:result_response]
      )
    end
    render status: 200
  end
end
