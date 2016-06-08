module BlueBank
  class Customer
    def initialize(client:)
      @client = client
    end

    def id
      json.fetch("id")
    end

    def given_name
      json.fetch("givenName")
    end

    def accounts
      @accounts ||= AccountList.new(customer: self, client: client)
    end

    def current_account
      accounts.find(&:current?)
    end

    private

    def json
      @json ||= client.get("/customers").first
    end

    attr_reader :client
  end
end
