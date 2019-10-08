require "rest-client"

class OauthLogger
  attr_accessor :provider
  
  def initialize(provider)

    @provider = provider
    case provider
    when :facebook, "facebook"
      @api_url = "https://graph.facebook.com/v4.0/me"
      @client_id = ENV["FACEBOOK_KEY"]
      @token_name = "access_token"
      @fields = {"fields": %w[name email picture.type(large)].join(",")} # require data
      @response = -> (res) { facebook_response(res) }
    when :google, "google"
      @api_url = "https://oauth2.googleapis.com/tokeninfo"
      @client_id = ENV["GOOGLE_KEY"]
      @token_name = "id_token"
      @fields = {}
      @response = -> (res) { google_response(res) }
    else
      raise "Provider not allowed"
      return false
    end

  end

  
  def perform(token)
    construct_response @res if confirm_token token
  end
  
  private
  
  def confirm_token(token)
    query = {@token_name => token}.merge(@fields)
    @res = RestClient.get(@api_url, params: query )
    http_status @res
  end

  def construct_response(res)
    res = JSON.parse(res)
    @response.call(res)
  end
  
  def facebook_response(res)
    {
      name: res["name"],
      email: res["email"],
      image_url: res["picture"]["data"]["url"],
      uid: res["id"]
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

  def http_status(res)
    if res.code == 200
      return true
    else
      raise "#{res.code} Error Occurred when login through #{@provider}"
      return false
    end
  end

end

