require 'spec/mocks'
require 'rspec-expectations'

class AfricasTalkingGateway
  
  def initialize(user_name,api_key)
    @user_name = user_name
    @api_key = api_key
  end
end

describe "The Africas Talking Gateway API" do
  it "should give an error message when there are no correct authentication details" do
  end
end