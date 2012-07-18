require 'rspec-expectations'
require_relative 'spec_helper'

describe "Africas Talking Gateway Api" do

  valid_api_key = "4f116c64a3087ae6d302b6961279fa46c7e1f2640a5a14a040d1303b2d98e560"
  valid_username = "kimenye"

  invalid_api_key = "invalid key"
  invalid_username = "invalid username"

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
    lambda { valid_api.send_message("+254705866564","Hello world!") }.should_not raise_error
  end

  it "should correctly encode the request parameters" do
    recipients = "+254705866564,+254706349037,+254727550098"
    msg = "Hello World!"

    body_str = invalid_api._encode_body(recipients,msg)
    body_str.should eq("username=invalid+username&to=%2B254705866564%2C%2B254706349037%2C%2B254727550098&message=Hello+World%21")
  end
end