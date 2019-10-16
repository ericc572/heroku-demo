require 'rest-client'

class AccessTokenRefresher
  def initialize(refresh_token)
    @refresh_token = refresh_token
  end

  def run
      RestClient.post('https://api.einstein.ai/v2/oauth2/token', {
        grant_type: 'refresh_token',
        refresh_token: refresh_token
    })
  end
end
