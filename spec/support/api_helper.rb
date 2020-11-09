module ApiHelper
  def authenticated_header(request, user, header)
    auth_headers = Devise::JWT::TestHelpers.auth_headers(header, user)
    request.headers.merge!(auth_headers)
  end

  def auth_bearer(user, header)
    auth_headers = Devise::JWT::TestHelpers.auth_headers(header, user)
    auth_headers["Authorization"]
  end
end

