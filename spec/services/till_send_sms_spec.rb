require 'rails_helper'

RSpec.describe TillSendSms do
  describe "#run" do
    let(:phone_number) { "+1234567890" }
    let(:text) { "Hi, how was your experience today?" }
    let(:grant_type) { "authorization_code" }
    let(:refresh_token) { "fake-refresh-token" }
    let(:access_token) { "fake-access-token" }
    let(:resource_id) { SecureRandom.uuid }
    let(:heroku_uuid) { SecureRandom.uuid }

    ex: "payload" = {
      "phone" => ["#{@phone_number}"],
      "questions" => [{
        "text" => "Hi! How was your camping experience today?",
        "tag" => "camping_rating",
        "webhook" => "https://typeform-dreamforce.herokuapp.com/hooks/sms_received"
      }],
      "conclusion" => "Thank you for your time!"
    }
    let!(:resource) { Resource.create!(heroku_uuid: heroku_uuid, plan: plan, oauth_grant_code: oauth_grant_code) }
    let(:plan) { "test" }
    let(:body) {
      {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "expires_in": 28800,
        "token_type": "Bearer",
      }
    }

  it 'makes a request to TILL with the proper payload'
  end
end
