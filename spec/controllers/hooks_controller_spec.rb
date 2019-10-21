require "rails_helper"

RSpec.describe HooksController do
    let(:submitted_at) { "#{Time.now.utc}" }
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
      {
        "submitted_at": submitted_at,
        "definition": definition,
        "answers": answers
      }
    }

    let(:params) {
      {
        "form_response": form_response
      }
    }


    it "returns a 200" do
      post :survey_created, params: params
      expect(response.code).to eq("200")
    end

    it "creates a new contact record" do
      expect{ post :survey_created, params: params }
       .to change(Contact, :count).by(1)
       expect(Resource.find_by(hd: "123")).to be_nil
    end
end
