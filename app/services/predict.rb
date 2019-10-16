require 'rest-client'

module PredictHelper
  def PredictHelper.predict(token, model_id, document)
      RestClient.post('https://api.einstein.ai/v2/language/sentiment',
                    {:document => document,
                     :modelId => model_id, :multipart => true},
                    headers = {:authorization=> "Bearer #{token}"})
  end
end
