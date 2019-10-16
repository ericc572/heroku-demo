require 'rest-client'

module AccessTokenRefresher
  def run(refresh_token)
      RestClient.post('https://api.einstein.ai/v2/oauth2/token', {
        grant_type: 'refresh_token',
        refresh_token: refresh_token
    })
  end
end
