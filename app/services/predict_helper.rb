require 'rest-client'

class PredictHelper
  def initialize(token, model_id, document)
    @token = token
    @model_id = model_id
    @document = document
  end

  def predict
      RestClient.post('https://api.einstein.ai/v2/language/sentiment',
                    {:document => document,
                     :modelId => model_id, :multipart => true},
                    headers = {:authorization=> "Bearer #{token}"})
  end
end
