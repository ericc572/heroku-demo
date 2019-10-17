require 'rest-client'

class TokenGenerator
  def initialize(assertion)
    @assertion = assertion
  end

  def generate_token
      RestClient.post('https://api.einstein.ai/v2/oauth2/token', {
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: @assertion,
        scope: 'offline'
    })
  end
end
