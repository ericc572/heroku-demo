require './einstein/jwt'
require './einstein/token_generator'
require './einstein/predict'
require 'json'
require 'highline/import'

if __FILE__ == $0
  accId = ENV['EINSTEIN_VISION_ACCOUNT_ID']

  text_input = ask "Enter a wall of text to analyze its sentiment: "
  # Remove all '\n' and add newline
  privKey = String.new(ENV['EINSTEIN_VISION_PRIVATE_KEY'])
  privKey.gsub!('\n', "\n")
  exp = Time.now.to_i + (60 * 15)

  # Generate an assertion using rsa private key
  assertion = JwtHelper.sign(accId, privKey, exp)

  # Obtain oauth token
  token = JSON.parse(TokenGenerator.generate_token(assertion))
  puts "\nGenerated access token:\n"
  puts JSON.pretty_generate(token)

  access_token = token["access_token"]
  refresh_token = token["refresh_token"]

  # if exp + 60 < (Time.now.utc)
  #   token = JSON.parse(AccessTokenRefresher.new(refresh_token).run)
  #   puts "Token was refreshed: #{token}"
  #   access_token = token["access_token"]
  # end

  puts "Enter a wall of text to predict its sentiment: "

  # Make a prediction call
  prediction_response = JSON.parse(
      PredictHelper.predict(access_token,
                            "CommunitySentiment",
                            text_input))

  puts "\nPrediction response:\n"
  puts JSON.pretty_generate(prediction_response)
end
