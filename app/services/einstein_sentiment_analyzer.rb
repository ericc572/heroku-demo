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
    sign_jwt_token
    predict_sentiment
  end

  private

  attr_accessor :account_id, :contact_id, :comment, :access_token

  def sign_jwt_token
    assertion = JwtHelper.new(account_id, Config.private_key, expires_at).sign
    generate_token(assertion)
  end

  def expires_at
    Time.now.to_i + (60 * 15)
  end

  def generate_token(assertion)
    token = JSON.parse(TokenGenerator.new(assertion).generate_token)
    puts "\nGenerated access token:\n"
    puts JSON.pretty_generate(token)
    @access_token = token["access_token"]
    refresh_token = token["refresh_token"]

    if expires_at + 60 < (Time.now.utc).to_i
      refresh_request(refresh_token)
    end
  end

  def refresh_request(refresh_token)
    token = JSON.parse(AccessTokenRefresher.new(refresh_token).run)
    puts "Token was refreshed: #{token}"
    @access_token = token["access_token"]
  end

  def predict_sentiment
    puts "Predicting sentiment of comment: #{comment}"

    # Make a prediction call
    puts access_token
    prediction_response = JSON.parse(
      PredictHelper.new(access_token, "CommunitySentiment", comment).predict)
    puts "\nPrediction response:\n"
    puts JSON.pretty_generate(prediction_response)
    update_contact
  end

  def update_contact
    percentage = prediction_response["probabilities"].find { |h| h["label"] == "positive" }["probability"]
    Contact.find(contact_id).update(customersatisfaction__c: percentage*100)
  end
end
