require 'json'
require 'rest-client'

class Config
  def self.account_id
    ENV["EINSTEIN_VISION_ACCOUNT_ID"]
  end

  def self.private_key
    ENV["EINSTEIN_VISION_PRIVATE_KEY"]
  end
end

class EinsteinSentimentAnalyzer
  def initialize(contact_id, comment)
    @account_id = Config.account_id
    @contact_id = contact_id
    @comment = comment
    @access_token = nil
  end

  def run
    exp = Time.now.to_i + (60 * 15)
    private_key = Config.private_key
    # private_key.gsub!('\n', "\n")

    assertion = JwtHelper.new(@account_id, private_key, exp).sign
    token = JSON.parse(TokenGenerator.new(assertion).generate_token)
    puts "\nGenerated access token:\n"
    puts JSON.pretty_generate(token)

    access_token = token["access_token"]
    refresh_token = token["refresh_token"]

    if exp + 60 < (Time.now.utc).to_i
      token = JSON.parse(AccessTokenRefresher.new(refresh_token).run)
      puts "Token was refreshed: #{token}"
      access_token = token["access_token"]
    end

    puts "Predicting sentiment of comment: #{@comment}"

    # Make a prediction call
    prediction_response = JSON.parse(
        PredictHelper.new(access_token,
                              "CommunitySentiment",
                              @comment).predict)

    puts "\nPrediction response:\n"
    puts JSON.pretty_generate(prediction_response)
    percentage = prediction_response["probabilities"].find { |h| h["label"] == "positive" }["probability"]
    Contact.find(@contact_id).update(customersatisfaction__c: percentage)
  end
end
