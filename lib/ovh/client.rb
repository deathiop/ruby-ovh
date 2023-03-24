require 'config'
require 'exceptions'

module OVH
  ENDPOINTS = {
    "ovh-eu" =>  "https://eu.api.ovh.com/1.0",
    "ovh-us" =>  "https://api.us.ovhcloud.com/1.0",
    "ovh-ca" =>  "https://ca.api.ovh.com/1.0",
    "kimsufi-eu" =>  "https://eu.api.kimsufi.com/1.0",
    "kimsufi-ca" =>  "https://ca.api.kimsufi.com/1.0",
    "soyoustart-eu" =>  "https://eu.api.soyoustart.com/1.0",
    "soyoustart-ca" =>  "https://ca.api.soyoustart.com/1.0",
  }

  TIMEOUT = 180

  class Client
    def initialize(
      endpoint:nil,
      application_key:nil,
      application_secret:nil,
      consumer_key:nil,
      timeout:TIMEOUT
    )
      configuration = ConfigurationManager.new

      @endpoint = endpoint || configuration.get('default', 'endpoint')
      unless ENDPOINTS.key?(endpoint)
        raise OVH::InvalidRegion.new("Unknown endpoint #{endpoint}. Valid endpoints: #{ENDPOINTS.keys}")
      end

      @application_key = application_key || configuration.get(endpoint, 'application_key')
      @application_secret = application_secret || configuration.get(endpoint, 'application_secret')
      @consumer_key = consumer_key || configuration.get(endpoint, 'consumer_key')
      @timeout = timeout
      @time_delta = nil
    end

    def time_delta
      if @time_delta.nil?
        server_time = self.get('/auth/time', _need_auth=false)
        @time_delta = server_time - Time.now.to_i
      end
      return @time_dela
    end

    def new_consumer_key_request
      return ConsumerKeyRequest.new(self)
    end

    def request_consumerkey(access_rules, redirect_url=nil)
      res = self.post("/auth/credential", _need_auth=False, accessRules=access_rules, redirection=redirect_url)
      @consumer_key = res["consumerKey"]
      return res
    end
  end
end
