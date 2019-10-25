require "rails_helper"
RSpec.describe HooksController do
  describe "survey_created" do
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
    }
    let(:phone_number) { "+1234567890" }
    let(:answers) { [
      {
        "type": "text",
        "text": "Matt",
        "field": {
          "id": "kSHzJrMOjcMD",
          "type": "short_text",
          "ref": "b78711bb4559132e"
        }
      },
      {
        "type": "text",
        "text": "matt@gmail.com",
        "field": {
          "id": "qFfhkmeEyC9G",
          "type": "short_text",
          "ref": "b78711bb4559132e"
        }
      },
      {
        "type": "phone_number",
        "phone_number": phone_number,
        "field": {
          "id": "AHFiyvOxGO7i",
          "type": "phone_number",
          "ref": "b78711bb4559132e"
        }
      }
     ]
    }

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

    it "creates a Contact object" do
      expect { post :survey_created, params: params }.to change(Contact, :count).by(1)
    end

    it "enqueues the SMS Till Job" do
      ActiveJob::Base.queue_adapter = :test
      post :survey_created, params: params

      expect(TillSendSmsJob)
      .to have_been_enqueued
      .with(phone_number: phone_number)
    end

    it "returns a 200" do
      post :survey_created, params: params
      expect(response.code).to eq("200")
    end
  end
end
