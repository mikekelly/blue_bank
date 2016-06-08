require 'json'
require 'rest-client'

module BlueBank
  class Client
    def initialize(subscriber_key:)
      @subscriber_key = subscriber_key
    end

    def get(path)
      JSON.parse(adapter.get(base_url + path, request_headers))
    end

    def post(path:, json:)
      JSON.parse(adapter.post(base_url + path, JSON.dump(json), request_headers))
    end

    def customer
      @customer ||= Customer.new(client: self)
    end

    private

    def base_url
      "https://bluebank.azure-api.net/api/v0.6.3"
    end

    def adapter
      RestClient
    end

    def request_headers
      {
        "Content-Type" => "application/json",
        "Ocp-Apim-Subscription-Key" => subscriber_key,
        "Bearer" => bearer,
      }
    end

    def bearer
      @bearer ||= jwt_from_cloudlevel.fetch("bearer")
    end

    def jwt_from_cloudlevel
      JSON.parse(adapter.get("https://cloudlevel.io/token", { "Ocp-Apim-Subscription-Key" => subscriber_key }))
    end

    attr_reader :subscriber_key
  end
end
