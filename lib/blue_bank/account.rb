module BlueBank
  class Account
    def initialize(id:, client:, json: nil)
      @id, @client, @json = id, client, json
    end

    def current?
      account_type == "Standard Current Account"
    end

    def savings?
      account_type == "Standard Current Account"
    end

    def account_type
      json.fetch("accountType")
    end

    def make_payment(account_number:, sort_code:, reference:, amount:)
      json = client.post(
        path: "/accounts/#{id}/payments",
        json: {
          "toAccountNumber" => account_number,
          "toSortCode" => sort_code,
          "paymentReference" => reference,
          "paymentAmount" => amount,
        }
      )
      Payment.new(id: json.fetch("id"), account: self, client: client, json: json)
    end

    def transactions
      client.get("/accounts/#{id}/transactions")
    end

    def id
      @id ||= json.fetch("id")
    end

    private

    def json
      @json ||= client.get("/accounts/#{id}").first
    end

    attr_reader :client
  end
end
