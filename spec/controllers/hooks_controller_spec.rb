require "rails_helper"

RSpec.describe HooksController do
  describe "POST /hooks/survey_created" do
    let(:submitted_at) { "#{Time.now.utc}"}
    let(:definition) {
      {
        "id": "DHsCKv",
        "title": "Customer Feedback Survey (copy)",
        "fields": [
          {
            "id": "kSHzJrMOjcMD",
            "title": "What is your name?",
            "type": "short_text",
            "ref": "f040ed23d66caed8",
            "properties": {}
          }
        ]
      }
    let(:answers) { [
      {
        "type": "text",
        "text": "matt@heroku.com",
        "field": {
          "id": "qFfhkmeEyC9G",
          "type": "short_text",
          "ref": "b78711bb4559132e"
        }
      }
     ] }

    let(:form_response) {
      submitted_at: submitted_at,
      definition: definition
      answers: answers
    }

    let(:params) {
      {
        "form_response": form_response
      }
    }
    before do
      Resource.create!(heroku_uuid: "123", plan: plan)
    end

    it "returns a 200" do
      post :survey_created, params: params

      expect(response.code).to eq("200")
    end

    it "has the correct JSON body" do
      expected = {
        id: heroku_id,
        message: "Hey ERIC!!! CHILDISH_GAMBINO is being provisioned.",
      }

      post :create, params: params
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected)
    end

    it "deletes the associated resource model" do
      delete :destroy, params: { "id": "123" }

      expect(Resource.find_by(heroku_uuid: "123")).to be_nil
    end
  end
end
