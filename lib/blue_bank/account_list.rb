module BlueBank
  class AccountList
    include Enumerable

    def initialize(customer:, client:)
      @customer, @client = customer, client
    end

    def each(&block)
      account_objects.each(&block)
    end

    private

    def account_objects
      json.map { |account_json|
        Account.new(id: account_json.fetch("id"), json: account_json, client: client)
      }
    end

    def json
      @json ||= client.get("/customers/#{customer.id}/accounts")
    end

    attr_reader :customer, :client
  end
end
