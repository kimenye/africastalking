require 'CGI'
require 'curb'
require 'json'
require 'URI'
require 'pry'

class AfricasTalkingGatewayAuthenticationError < Exception
end

class AfricasTalkingGatewayUnexpectedError < Exception
end

class SMSMessage
  attr_accessor :id, :text, :from, :date

  def initialize(m_id, m_text,m_from,m_date)
    @id = m_id
    @text = m_text
    @from = m_from
    @date = m_date
  end
end

#class MessageStatusReport
#
#  #attr_accessor
#end

class AfricasTalkingGateway

  #Constants
  URL = 'https://api.africastalking.com/version1/messaging'
  ACCEPT_TYPE = 'application/json'

  def initialize(user_name,api_key)
    @user_name = user_name
    @api_key = api_key
  end

  def send_message(recipients, message)
    data = nil
    response_code = nil

    #http = Curl.post("")
  end

  def fetch_messages(last_received_id)
    data = nil
    response_code = nil

    http = Curl.get("#{URL}?username=#{@user_name}&lastReceivedId=#{last_received_id}") do |curl|
      curl.headers['Accept'] = ACCEPT_TYPE
      curl.headers['apiKey'] = @api_key
      curl.verbose = false
      curl.on_body { |body| data = body }
      curl.on_complete { |resp| response_code = resp.response_code }
    end

    raise AfricasTalkingGatewayAuthenticationError if response_code == 401
    raise AfricasTalkingGatewayUnexpectedError "Data is nil for some unexpected reason" if response_code != 200 or data.nil?

    messages = JSON.parse(data)["SMSMessageData"]["Messages"].collect { |msg|
      SMSMessage.new msg["id"], msg["text"], msg["to"], msg["date"]
    }
  end

  def _encode_body(recipients,message)
    URI.encode_www_form([['username', @user_name], ['to', recipients], ['message', message]])
  end
end
