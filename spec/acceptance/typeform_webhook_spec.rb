require 'rack/test'
require 'json'
require 'rails_helper'
module TypeformWebhooks
  RSpec.describe 'Typeform Webhook POST method', :type => :request do
    include Rack::Test::Methods
    let(:payload) {
      {
        "event_id": "01DQDVZ0MS8CTJDYVP6KD57J78",
        "event_type": "form_response",
        "form_response": {
          "form_id": "DHsCKv",
          "token": "qcy0wyokfyuo3h6ek3za7qcy0wyoj7wc",
          "landed_at": "2019-10-17T22:03:12Z",
          "submitted_at": "2019-10-17T22:03:43Z",
          "definition": {
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
          },
          "answers": [
            {
              "type": "text",
              "text": "matt@heroku.com",
              "field": {
                "id": "qFfhkmeEyC9G",
                "type": "short_text",
                "ref": "b78711bb4559132e"
              }
            }
          ]
        }
      }
    }

    it 'saves the survey responses' do
      post '/hooks/survey_created', JSON.generate(payload)
      expect(last_response.status).to eq(200)
      response = JSON.parse(last_response.body)
    end

    it 'creates a contact' do
      expect { post '/hooks/survey_created', JSON.generate(payload)}.to change(Contact, :count).by(1)
    end
  end
end
