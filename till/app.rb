require 'rest-client'
require 'json'

if __FILE__ == $0
  url = ENV['TILL_URL']

  payload = {
    "phone" => ["14154703971"],
    "questions" => [{
      "text" => "Hi! What is your favorite color?",
      "tag" => "favorite_color",
      "responses" => ["Red", "Green", "Yellow"],
      "webhook" => "https://typeform-dreamforce.herokuapp.com/hooks/sms_received"
    }],
    "conclusion" => "Thank you for your time!"
  }

  response = JSON.parse(RestClient.post(url, payload.to_json, content_type: :json))
  puts "After sending SMS"
  puts JSON.pretty_generate(response)
end

