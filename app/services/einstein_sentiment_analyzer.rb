require 'json'
require 'rest-client'
require '../services'

class Config
  def self.account_id
    ENV.fetch("EINSTEIN_VISION_ACCOUNT_ID")
  end

  def self.private_key
    ENV.fetch("EINSTEIN_VISION_PRIVATE_KEY")
  end
end

class EinsteinSentimentAnalyzer
  def initialize(comment)
    @account_id = Config.account_id
    @private_key = Config.private_key
    @comment = comment
    @access_token = nil
  end

  def run
    exp = Time.now.to_i + (60 * 15)
    private_key.gsub!('\n', "\n")

    assertion = JwtHelper.sign(account_id, private_key, exp)
    token = JSON.parse(TokenGenerator.generate_token(assertion))
    puts "\nGenerated access token:\n"
    puts JSON.pretty_generate(token)

    access_token = token["access_token"]
    refresh_token = token["refresh_token"]

    if exp + 60 < (Time.now.utc)
      token = JSON.parse(AccessTokenRefresher.new(refresh_token).run)
      puts "Token was refreshed: #{token}"
      access_token = token["access_token"]
    end

    puts "Predicting sentiment of comment: #{comment}"

    # Make a prediction call
    prediction_response = JSON.parse(
        PredictHelper.predict(access_token,
                              "CommunitySentiment",
                              comment))

    puts "\nPrediction response:\n"
    puts JSON.pretty_generate(prediction_response)
    prediction_response[:probabilities].find { |h| h[:label] == "positive" }[:probability],
  end

  private
end