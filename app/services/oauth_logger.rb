require "rest-client"
#purpose: give provider & token to get the response data from provider
class OauthLogger < ApplicationService
  # attr_reader :provider, :token

  def initialize(provider, token)
    @provider = provider
    @token = token

    if is_correct_provider?
      @setting = find_setting_by_provider
    else
      raise "Provider not found"
      return false
    end

  end

  def call
    data = get_valid_data
    return construct_response data if http_status_success? data
  end
  
  
  private

  def find_setting_by_provider
    send "#{@provider}_format"
  end

  def is_correct_provider?
    providers = %w[ facebook google ]
    providers.include?(@provider)
  end
  
  def get_valid_data
    RestClient.get( @setting[:api_url], params: request_query )
  end

  def construct_response(res)
    res = JSON.parse(res)
    @setting[:response_hash].call(res)
  end

  def request_query
    query = { @setting[:token_name] => @token }
    if @setting[:fields].present?
      qurey.merge({ fields: @setting[:fields] })
    else
      query
    end
  end

  def http_status_success?(res)
    if res.code == 200
      return true
    else
      raise "#{res.code} Error Occurred when login through #{@provider}"
      return false
    end
  end
  
  def facebook_response(res)
    {
      name: res["name"],
      email: res["email"],
      image_url: res["picture"]["data"]["url"],
      uid: res["id"]
    }
  end
  
  def facebook_format
    {
      api_url: "https://graph.facebook.com/v4.0/me",
      token_name: "access_token",
      fields: %w[name email picture.type(large)].join(","),
      response_hash: ->(res){ facebook_response(res) }
    }
  end

  def google_response(res)
    {
      name: res["name"],
      email: res["email"],
      image_url: res["picture"],
      uid: res["sub"]
    }
  end

  def google_format
    {
      api_url: "https://oauth2.googleapis.com/tokeninfo",
      token_name: "id_token",
      fields: nil,
      response_hash: ->(res){ google_response(res) }
    }
  end

end
