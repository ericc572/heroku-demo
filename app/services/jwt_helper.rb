require 'jwt'

class JwtHelper
  def initialize(subject, privateKey, expiry)
    @subject = subject
    @privateKey = privateKey
    @expiry = expiry
  end

  def sign
    rsa_private = OpenSSL::PKey::RSA.new(privateKey)
    payload = {
        :sub => subject,
        :aud => "https://api.einstein.ai/v1/oauth2/token",
        :exp => expiry
    }
    assertion = JWT.encode payload, rsa_private, 'RS256'
    assertion
  end
end
