module TokenAuthenticationHelpers
  def make_valid_api_credentials(user = nil)
    user ||= create :user, email: 'a@b.c'

    request = double('request', remote_ip: '127.0.0.1', user_agent: 'micks-download-agent')
    token = Tiddle.create_and_return_token(user, request)
    {
      'X-USER-EMAIL' => user.email,
      'X-USER-TOKEN' => token
    }
  end
end
