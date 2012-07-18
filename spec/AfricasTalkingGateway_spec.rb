require 'rspec-expectations'
require_relative 'spec_helper'

describe "Africas Talking Gateway Api" do

  valid_api_key = "<Enter your api key here>"
  valid_username = "<Enter your username here>"

  invalid_api_key = "invalid key"
  invalid_username = "invalid username"

  send_response = {
      :SMSMessageData => {
          :Message => "Sent to 1\/1 Total Cost: KES 1.50",
          :Recipients => [
              {
                  :number => "2537655332",
                  :status => "Success",
                  :cost => "KES 1.50"
              }
          ]
      }
  }

  invalid_api = AfricasTalkingGateway.new(invalid_username, invalid_api_key)
  valid_api = AfricasTalkingGateway.new(valid_username, valid_api_key)

  it "should throw an AuthenticationError when there are no correct authentication details" do
    lambda { invalid_api.fetch_messages(400) }.should raise_error AfricasTalkingGatewayAuthenticationError
  end

  it "should not throw an AuthenticationError when there are correct authentication details" do
    lambda { valid_api.fetch_messages(400) }.should_not raise_error AfricasTalkingGatewayAuthenticationError
  end

  it "should return sms messages when fetching with correct credentials and criteria" do
    lambda { valid_api.fetch_messages(0) }.should_not raise_error AfricasTalkingGatewayUnexpectedError
    messages = valid_api.fetch_messages(0)
    messages.length.should > 0
  end

  it "should send sms messages when correct credentials and criteria are set" do
    lambda { valid_api.send_message("+2547771234567,+2547771234568,+2547771234569","Hello world!") }.should_not raise_error
  end

  it "should correctly parse the json response to the send method" do
    resp = MessageStatusReport.new(send_response.to_json)
    resp.total_cost.should eq(1.50)
    resp.number_successful.should eq(1)
    resp.total_number.should eq(1)
    resp.status_reports.length.should eq(1)
  end
end