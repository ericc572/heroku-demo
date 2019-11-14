require 'rest-client'
require 'json'

class TillSendSms

  def initialize(phone_number)
    @phone_number = phone_number
  end


  def run
    url = ENV['TILL_URL']

    payload = {
      "phone" => ["#{@phone_number}"],
      "questions" => [{
        "text" => "Hi! How was your camping experience today?",
        "tag" => "camping_rating",
        "webhook" => "https://happy-trails-campground.herokuapp.com/hooks/sms_received"
      }],
      "conclusion" => "Thank you for your feedback. I hope you had an excellent experience!"
    }

    response = JSON.parse(RestClient.post(url, payload.to_json, content_type: :json))
    puts "After sending SMS"
    puts JSON.pretty_generate(response)
  end
end
