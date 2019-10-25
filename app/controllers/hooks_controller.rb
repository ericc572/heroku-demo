class HooksController < ApplicationController
  FIELD_MAPPINGS = {
    :name => 'kSHzJrMOjcMD',
    :email => 'qFfhkmeEyC9G',
    :comment => 'uGwJkwgN6GEK',
    :phone_number => 'AHFiyvOxGO7i'
  }

  TYPE_MAPPINGS = {
    :name => "text",
    :email => "text",
    :comment => "text",
    :phone_number => "phone_number"
  }

  def survey_created
    # If the body contains the form_response parameter...
    data = params[:form_response]
    if data.present?
      # Create a new Survey object based on the received parameters...
      questions = data[:definition]
      answers = data[:answers]
      time = data[:submitted_at]

      phone_number = answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:phone_number] }[TYPE_MAPPINGS[:phone_number]]
      #comment = answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:comment] }[TYPE_MAPPINGS[:comment]]

      contact = Contact.create!(
        lastname: answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:name] }[TYPE_MAPPINGS[:name]],
        email: answers.find { |h| h[:field][:id] == FIELD_MAPPINGS[:email] }[TYPE_MAPPINGS[:email]],
        phone: phone_number
        # customersatisfaction__c: positive_percentage
      )

      #puts "comment: #{comment}"

      puts "Sending till SMS:"
      TillSendSmsJob.perform_later(phone_number: phone_number)

    end
    render status: 200, json: @s.to_json
  end

  def sms_received
    puts "SMS was received. Saving data now: "
    if params.present?
      # SmsResponse.create!(
      #   phone_number: params[:participant_phone_number],
      #   question: params[:question_text],
      #   response_timestamp: params[:result_timestamp],
      #   response_answer: params[:result_answer],
      #   response_answer: params[:result_response]
      # )
      response = params[:result_answer]
      puts "Answer from user: #{response}"
      contact = Contact.where(phone: params[:participant_phone_number]).last
      EinsteinSentimentAnalyzerJob.perform_later(contact.id, response)
    end


    render status: 200
  end
end
